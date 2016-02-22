//
//  NoteEditViewController+Reader.swift
//  X2015
//
//  Created by Hang Zhang on 2/20/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import AVFoundation

extension NoteEditViewController {

	@IBAction func playButtonPressed(sender: UIBarButtonItem) {
		guard
			let noteContent = noteManager?.noteContent,
			let noteTitle = noteManager?.currentTitle else {
				fatalError()
		}

		let controller = NoteReaderController.sharedInstance
		controller.prepare(noteTitle, note: noteContent)
		let toolBar = setupReaderToolBarAndReturn()
		controller.view = toolBar

		NSNotificationCenter
			.defaultCenter()
			.addObserverForName(
				NoteReaderControllerDidChangeReadingActionNotificationName,
				object: nil,
				queue: NSOperationQueue.mainQueue()) { (note) -> Void in
					guard let typeRawValue = note.userInfo?[NoteReaderControllerTypeKey] as? String else {
						fatalError()
					}
					guard let type = NoteReaderController.ReadingActionType(rawValue: typeRawValue) else {
						fatalError()
					}

					switch type {
					case .DidStart:
						self.setReaderModeEnabled(true)
					case .DidFinish, .DidCancel:
						self.setReaderModeEnabled(false)
					default:
						break
					}

		}

		controller.startReading()
	}

	func stopNoteReaderIfActive() {
		NoteReaderController.sharedInstance.destoryIfActive()
	}

	private func setupReaderToolBarAndReturn() -> NoteReaderControllerToolBar {
		readerToolBar = NoteReaderControllerToolBar.instantiateFromNib()!
		guard let toolbar = readerToolBar else {
			fatalError()
		}
		view.addSubview(toolbar)
		toolbar.configureTheme(currentTheme)
		toolbar.translatesAutoresizingMaskIntoConstraints = false
		view.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|[view]|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: ["view":toolbar]))
		view.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:[view]|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: ["view":toolbar]))
		return toolbar
	}

	func setReaderModeEnabled(enabled: Bool) {
		guard let toolBar = readerToolBar else {
			fatalError()
		}
		if enabled {
			playButton.enabled = false
			textView.selectable = false
			textView.editable = false
			textView.contentInset.bottom = CGRectGetHeight(toolBar.bounds)
			becomeFirstResponder()
		} else {
			playButton.enabled = true
			textView.selectable = true
			textView.editable = true
			readerToolBar?.removeFromSuperview()
			textView.contentInset.bottom = 0
		}
	}

}
