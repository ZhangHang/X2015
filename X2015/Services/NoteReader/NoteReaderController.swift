//
//  NoteReaderController.swift
//  X2015
//
//  Created by Hang Zhang on 2/20/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import AVFoundation

final class NoteReaderController: NSObject {

	let view: NoteReaderControllerToolBar = NoteReaderControllerToolBar.instantiateFromNib()!

	let note: String!

	private(set) var speechSynthesizer: AVSpeechSynthesizer!
	private(set) var speechUtterance: AVSpeechUtterance!
	private(set) var currentCharacterRange: NSRange = NSMakeRange(0, 0)

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
			view.speedButton.title = currentSpeed.rawValue
			speechSynthesizer.delegate = nil
			speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
			if !isCurrentPaused {
				startReading()
			}
		}
	}

	init(note: String, readImmediately: Bool = true) {
		self.note = note

		super.init()

		configureView()
		if readImmediately {
			startReading()
		}
		speechSynthesizer = AVSpeechSynthesizer()
	}

	var didStartReading: (() -> Void)?
	var didFinishReading: (() -> Void)?
	var didPauseReading: (() -> Void)?
	var didContinueReading: (() -> Void)?
	var didCancelReading: (() -> Void)?
	var willSpeakRangeOfString: ((text: String, range: NSRange) -> Void)?

	private func resetSpeechUtterance() {
		let noteString = note as NSString
		let string = noteString.substringFromIndex(currentCharacterRange.location)
		speechUtterance = AVSpeechUtterance(string: string)
		speechUtterance.rate = currentSpeed.toRate()
		speechSynthesizer = AVSpeechSynthesizer()
		speechSynthesizer.delegate = self
	}

	func startReading() -> Void {
		view.isPlaying = false
		if speechSynthesizer.paused {
			speechSynthesizer.continueSpeaking()
		} else {
			resetSpeechUtterance()
			speechSynthesizer.speakUtterance(speechUtterance)
		}
	}

	private func configureView() {
		view.isPlaying = false

		// Can't use nor [owned self] or [weak self] in the blocks below
		// otherwise we would get an fatal error `attempted to retain deallocated object`
		// Bug?
		view.didPressedPlayButton = { view in
			precondition(view.isPlaying == false)
			if self.speechSynthesizer.paused {
				self.speechSynthesizer.continueSpeaking()
			} else {
				self.speechSynthesizer.speakUtterance(self.speechUtterance)
			}
		}

		view.didPressedPauseButton = { view in
			precondition(view.isPlaying == true)
			self.speechSynthesizer.pauseSpeakingAtBoundary(.Immediate)
		}

		view.didPressedStopButton = { view in
			self.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
			self.didCancelReading?()
		}

		view.didPressedFastForwardButton = { view in
		}

		view.didPressedRewindButton = { view in
		}

		view.didPressedSpeedButton = { view in
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

	func destory() {
		if speechSynthesizer.speaking {
			speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
		}
		didStartReading = nil
		didFinishReading = nil
		didPauseReading = nil
		didContinueReading = nil
		didCancelReading = nil
		willSpeakRangeOfString = nil
	}

}

extension NoteReaderController: AVSpeechSynthesizerDelegate {

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didStartSpeechUtterance utterance: AVSpeechUtterance) {
			didStartReading?()
			view.isPlaying = true
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didFinishSpeechUtterance utterance: AVSpeechUtterance) {
			didFinishReading?()
			view.isPlaying = false
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didPauseSpeechUtterance utterance: AVSpeechUtterance) {
			didPauseReading?()
			view.isPlaying = false
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didContinueSpeechUtterance utterance: AVSpeechUtterance) {
			didContinueReading?()
			view.isPlaying = true
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		didCancelSpeechUtterance utterance: AVSpeechUtterance) {
			debugPrint("cancled")
			didCancelReading?()
			view.isPlaying = false
	}

	func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
		willSpeakRangeOfSpeechString characterRange: NSRange,
		utterance: AVSpeechUtterance) {
			let text = (note as NSString).substringWithRange(characterRange)
			currentCharacterRange = characterRange
			willSpeakRangeOfString?(text: text, range: characterRange)
	}

}
