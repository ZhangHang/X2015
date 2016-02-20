//
//  NoteEditViewController+Reader.swift
//  X2015
//
//  Created by Hang Zhang on 2/20/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	@IBAction func playButtonPressed(sender: UIBarButtonItem) {
		guard let noteContent = noteManager?.noteContent else {
			fatalError()
		}

		let controller = NoteReaderController(note: noteContent, readImmediately: false)
		noteReaderController = controller
		controller.configureTheme(currentTheme)
		addReaderToolBar(controller)

		controller.didStartReading = { [unowned self] in
			self.playButton.enabled = false
		}
		controller.didFinishReading = { [unowned self] in
			self.playButton.enabled = true
			self.enableEditor()
			self.removeReaderToolBar()
			self.noteReaderController?.destory()
		}
		controller.didCancelReading = { [unowned self] in
			self.playButton.enabled = true
			self.enableEditor()
			self.removeReaderToolBar()
			self.noteReaderController?.destory()
		}

		disableEditor()
		controller.startReading()
	}

	func destroyNoteReaderControllerIfNeeded() {
		self.noteReaderController?.destory()
	}

	private func addReaderToolBar(controller: NoteReaderController) {
		self.view.addSubview(controller.view)
		controller.view.tintColor = UIColor.x2015_BlueColor()
		controller.view.translatesAutoresizingMaskIntoConstraints = false
		self.view.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|[view]|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: ["view":controller.view]))
		self.view.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:[view]|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: ["view":controller.view]))
	}

	private func removeReaderToolBar() {
		guard let controller = noteReaderController else {
			fatalError()
		}
		controller.view.removeFromSuperview()
	}

	private func disableEditor() {
		textView.selectable = false
		textView.editable = false
	}

	private func enableEditor() {
		textView.selectable = true
		textView.editable = true
	}

}
