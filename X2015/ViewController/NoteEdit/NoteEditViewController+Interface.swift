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

		let isEditing = textView.isFirstResponder()

		return isEditing
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
			navigationController?.hidesBarsOnSwipe = false
			navigationController?.hidesBarsOnTap = true
			navigationController?.hidesBarsWhenKeyboardAppears = true
		case .Edit:
			navigationController?.hidesBarsOnSwipe = false
			navigationController?.hidesBarsOnTap = true
			navigationController?.hidesBarsWhenKeyboardAppears = true
		case .Empty:
			navigationController?.hidesBarsOnSwipe = false
			navigationController?.hidesBarsOnTap = false
			navigationController?.hidesBarsWhenKeyboardAppears = false
		}

	}

	/**
	Update Editor title
	*/
	func updateTitleIfNeeded() {
		if let updater = noteUpdater {
			let noteTitle =  updater.noteTitle
			if noteTitle != title {
				title = updater.noteTitle
			}
		} else {
			title = nil
		}
	}

	/**
	Update sharing button based on whether note is empty or not
	*/
	func updateActionButtonIfNeeded() {
		if let updater = noteUpdater {
			actionBarButton.enabled = updater.noteContent?.isEmpty ?? false
		} else {
			actionBarButton.enabled = false
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
			emptyWelcomeView?.removeFromSuperview()
			textView.hidden = false
			textView.loadText_WORKAROUND(noteUpdater!.noteContent)
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		case .Create(_):
			emptyWelcomeView?.removeFromSuperview()
			textView.hidden = false
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
