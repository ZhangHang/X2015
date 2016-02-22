//
//  NoteReaderController.swift
//  X2015
//
//  Created by Hang Zhang on 2/20/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

//swiftlint:disable variable_name
//swiftlint:disable variable_name_max_length
//swiftlint:disable line_length
let NoteReaderControllerDidChangeReadingActionNotificationName = "NoteReaderControllerDidChangeReadingActionNotificationName"
let NoteReaderControllerTypeKey = "NoteReaderControllerTypeKey"

let NoteReaderControllerWillSpeakRangeOfStringNotificationName = "NoteReaderControllerWillSpeakRangeOfStringNotificationName"
let NoteReaderControllerWillSpeakRangeOfStringRangeKey = "NoteReaderControllerWillSpeakRangeOfStringRangeKey"
let NoteReaderControllerWillSpeakRangeOfStringKey = "NoteReaderControllerWillSpeakRangeOfStringKey"
//swiftlint:enable line_length
//swiftlint:enable variable_name_max_length
//swiftlint:enable variable_name


class Box<T>: NSObject {
	let value: T
	init(value: T) {
		self.value = value
	}
}

final class NoteReaderController: NSObject {

	static let sharedInstance = NoteReaderController()

	enum ReadingActionType: String {
		case None
		case DidStart
		case DidFinish
		case DidPause
		case DidContinue
		case DidCancel
	}

	var actionType: ReadingActionType = .None {
		didSet {
			debugPrint(actionType.rawValue)

			if actionType == .None {
				return
			}

			let userInfo = [
				NoteReaderControllerTypeKey: actionType.rawValue
			]

			NSNotificationCenter
				.defaultCenter()
				.postNotificationName(
					NoteReaderControllerDidChangeReadingActionNotificationName,
					object: nil,
					userInfo: userInfo)
		}
	}

	weak var view: NoteReaderControllerToolBar? {
		didSet {
			configureToolBar()
		}
	}

	private(set) var isAudioSessionActive: Bool = false

	private(set) var note: String!
	private(set) var title: String!

	private(set) var speechSynthesizer: AVSpeechSynthesizer!
	private(set) var speechUtterance: AVSpeechUtterance!
	private(set) var currentCharacterRange: NSRange?

	enum Speed: String {
		case Slow = ".5X"
		case Normal = "1X"
		case Fast = "2X"

		func toRate() -> Float {
			switch self {
			case .Slow:
				return (AVSpeechUtteranceMinimumSpeechRate + AVSpeechUtteranceDefaultSpeechRate) / 2
			case .Normal:
				return AVSpeechUtteranceDefaultSpeechRate
			case .Fast:
				return (AVSpeechUtteranceMaximumSpeechRate + AVSpeechUtteranceDefaultSpeechRate) / 2
			}
		}
	}

	private(set) var currentSpeed: Speed = .Normal {
		didSet {
			let isCurrentPaused = speechSynthesizer.paused
			view?.speedButton.title = currentSpeed.rawValue
			speechSynthesizer.delegate = nil
			speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
			if !isCurrentPaused {
				startReading()
			}
		}
	}

	override init() {
		super.init()

		NSNotificationCenter
			.defaultCenter()
			.addObserver(
				self,
				selector: "handleMediaResetNotification:",
				name: AVAudioSessionMediaServicesWereResetNotification,
				object: nil)
		NSNotificationCenter
			.defaultCenter()
			.addObserver(
				self,
				selector: "handleAudioSessionInterruptionNotification:",
				name: AVAudioSessionInterruptionNotification,
				object: nil)
		NSNotificationCenter
			.defaultCenter()
			.addObserver(
				self,
				selector: "handleAudioSessionSilenceSecondaryAudioHintNotification:",
				name: AVAudioSessionSilenceSecondaryAudioHintNotification,
				object: nil)

		configureAudioSession()
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	func prepare(title: String, note: String) {
		self.note = note
		self.title = title

		deactiveAudioSession()

		speechSynthesizer = AVSpeechSynthesizer()
		configureAudioSession()
	}

	private func resetSpeechUtterance() {
		let noteString = note as NSString
		if currentCharacterRange == nil {
			currentCharacterRange = NSMakeRange(0, 0)
		}
		let string = noteString.substringFromIndex(currentCharacterRange!.location)
		speechUtterance = AVSpeechUtterance(string: string)
		speechUtterance.rate = currentSpeed.toRate()
		speechSynthesizer = AVSpeechSynthesizer()
		speechSynthesizer.delegate = self
	}

	func startReading() -> Void {
		view?.isPlaying = false
		if speechSynthesizer.paused {
			speechSynthesizer.continueSpeaking()
		} else {
			resetSpeechUtterance()
			speechSynthesizer.speakUtterance(speechUtterance)
		}
	}

	private func configureAudioSession() {
		let session = AVAudioSession.sharedInstance()
		_ = try? session.setCategory(AVAudioSessionCategoryPlayback)
	}

	private func activeAudioSession() {
		let session = AVAudioSession.sharedInstance()
		_ = try? session.setActive(true)
		UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
		isAudioSessionActive = true
	}

	private func deactiveAudioSession() {
		let session = AVAudioSession.sharedInstance()
		_ = try? session.setActive(false, withOptions: .NotifyOthersOnDeactivation)
		UIApplication.sharedApplication().endReceivingRemoteControlEvents()
		isAudioSessionActive = false
	}

	func destoryIfActive() {
		if !isAudioSessionActive {
			return
		}
		speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
	}

}

extension NoteReaderController {
	func handleMediaResetNotification(note: NSNotification) {
		debugPrint("handleMediaResetNotification")
		configureAudioSession()
		activeAudioSession()
		// TODOs: handle speaking status
	}

	func handleAudioSessionInterruptionNotification(note: NSNotification) {
		debugPrint("handleAudioSessionInterruptionNotification")
		guard let type = note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt else {
			fatalError()
		}
		guard let interruptionType = AVAudioSessionInterruptionType(rawValue: type) else {
			fatalError()
		}

		switch interruptionType {
		case .Began:
			break
		case .Ended:
			break
		}

		guard let interruptionOption = note.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {
			return
		}
		if AVAudioSessionInterruptionOptions(rawValue: interruptionOption).contains(.ShouldResume) {
			// ...
		}

	}

	func handleAudioSessionSilenceSecondaryAudioHintNotification(note: NSNotification) {
		debugPrint("handleAudioSessionSilenceSecondaryAudioHintNotification")
		guard
			let why = note.userInfo?[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
			let type = AVAudioSessionSilenceSecondaryAudioHintType(rawValue:why) else {
				return
		}

		switch type {
		case .Begin:
			// silence secondary audio
			return
		case .End:
			// resume secondary audio
			return
		}
	}
}

extension NoteReaderController: AVSpeechSynthesizerDelegate {

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didStartSpeechUtterance utterance: AVSpeechUtterance) {
			actionType = .DidStart
			view?.isPlaying = true
			activeAudioSession()
			// Update now playing infomation
			MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
				MPMediaItemPropertyAlbumTitle: title,
				MPMediaItemPropertyArtist: "X2015"
			]
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didFinishSpeechUtterance utterance: AVSpeechUtterance) {
			actionType = .DidFinish
			view?.isPlaying = false
			currentCharacterRange = nil
			deactiveAudioSession()
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didPauseSpeechUtterance utterance: AVSpeechUtterance) {
			actionType = .DidPause
			view?.isPlaying = false
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didContinueSpeechUtterance utterance: AVSpeechUtterance) {
			actionType = .DidContinue
			view?.isPlaying = true
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didCancelSpeechUtterance utterance: AVSpeechUtterance) {
			actionType = .DidCancel
			view?.isPlaying = false
			currentCharacterRange = nil
			deactiveAudioSession()
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		willSpeakRangeOfSpeechString characterRange: NSRange,
		utterance: AVSpeechUtterance) {
			let text = (note as NSString).substringWithRange(characterRange)
			currentCharacterRange = characterRange

			let userInfo = [
				NoteReaderControllerWillSpeakRangeOfStringKey: text,
				NoteReaderControllerWillSpeakRangeOfStringRangeKey: Box(value: characterRange)
			]
			NSNotificationCenter
				.defaultCenter()
				.postNotificationName(
					NoteReaderControllerWillSpeakRangeOfStringNotificationName,
					object: nil,
					userInfo: userInfo)
	}

}

extension NoteReaderController {

	func configureToolBar() {
		guard let toolBar = view else {
			fatalError()
		}

		toolBar.isPlaying = false
		toolBar.didPressedPlayButton = { [unowned self] view in
			precondition(view.isPlaying == false)
			if self.speechSynthesizer.paused {
				self.speechSynthesizer.continueSpeaking()
			} else {
				self.speechSynthesizer.speakUtterance(self.speechUtterance)
			}
		}
		toolBar.didPressedPauseButton = { [unowned self] view in
			precondition(view.isPlaying == true)
			self.speechSynthesizer.pauseSpeakingAtBoundary(.Immediate)
		}
		toolBar.didPressedStopButton = { [unowned self] view in
			self.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
		}
		toolBar.didPressedSpeedButton = { [unowned self] view in
			switch self.currentSpeed {
			case .Slow:
				self.currentSpeed = .Normal
			case .Normal:
				self.currentSpeed = .Fast
			case .Fast:
				self.currentSpeed = .Slow
			}
		}
	}

}
