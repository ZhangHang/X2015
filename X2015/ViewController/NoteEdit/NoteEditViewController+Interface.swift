//
//  NoteEditViewController+Interface.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
		return .Slide
	}

	// Hide status bar if user is editing
	override func prefersStatusBarHidden() -> Bool {
		if !isViewLoaded() {
			return false
		}
		return textView.isFirstResponder()
	}

}

extension NoteEditViewController {

	func updateInterface() {
		updateTitleIfNeeded()
		updateActionButtonIfNeeded()

		// start edit immediately
		switch editingMode {
		case .Create:
			textView.becomeFirstResponder()
		default:
			break
		}

	}

	/**
	Update Editor title
	*/
	func updateTitleIfNeeded() {
		if let manager = noteManager {
			let noteTitle =  manager.currentTitle
			if noteTitle != title {
				title = manager.currentTitle
			}
		} else {
			title = nil
		}
	}

	/**
	Update bar buttons based on whether note is empty or not
	*/
	func updateActionButtonIfNeeded() {
		if let updater = noteManager {
			actionButton.enabled = !updater.isCurrentNoteEmpty
			playButton.enabled = !updater.isCurrentNoteEmpty
		} else {
			actionButton.enabled = false
			playButton.enabled = false
		}
	}

}

extension NoteEditViewController {

	func configureInterface(mode: EditingMode) {
		switch editingMode {
		case .Empty:
			textView.hidden = true
			emptyWelcomeView = setupEmptyWelcomeViewAndReturn()
		case .Edit(_, _):
			textView.loadText_WORKAROUND(noteManager!.noteContent)
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		case .Create(_):
			textView.loadText_WORKAROUND("")
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		}
	}

	private func setupEmptyWelcomeViewAndReturn() -> EmptyNoteWelcomeView {
		guard let emptyView = EmptyNoteWelcomeView.instantiateFromNib() else {
			fatalError()
		}
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(emptyView)
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[welcomeView]-0-|",
			options: .DirectionLeadingToTrailing,
			metrics: nil,
			views: ["welcomeView": emptyView]))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[welcomeView]-0-|",
			options: .DirectionLeadingToTrailing,
			metrics: nil,
			views: ["welcomeView": emptyView]))
		view.bringSubviewToFront(emptyView)

		return emptyView
	}

}
