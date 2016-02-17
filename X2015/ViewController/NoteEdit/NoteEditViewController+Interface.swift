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

	override func prefersStatusBarHidden() -> Bool {
		if !isViewLoaded() {
			return false
		}

		let isEditing = textView.isFirstResponder()

		return isEditing
	}

}

extension NoteEditViewController {

	func configureInterface(mode: Mode) {
		switch noteActionMode {
		case .Empty:
			textView.hidden = true
			emptyWelcomeView = setupEmptyWelcomeViewAndReturn()
		case .Edit(_, _):
			emptyWelcomeView?.removeFromSuperview()
			textView.hidden = false
			loadText_WORKAROUND(noteUpdater!.noteContent)
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		case .Create(_):
			emptyWelcomeView?.removeFromSuperview()
			textView.hidden = false
			loadText_WORKAROUND("")
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		}

		updateActionButtonIfNeeded()
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
