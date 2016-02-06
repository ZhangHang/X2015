//
//  MainSplitViewController.swift
//  X2015
//
//  Created by Hang Zhang on 2/7/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {

	var noteTimelineViewController: NoteTimelineTableViewController {
		guard
			let nc = self.childViewControllers.first as? UINavigationController,
			let vc = nc.childViewControllers.first as? NoteTimelineTableViewController else {
				fatalError()
		}
		return vc
	}
	var noteEditViewController: NoteEditViewController {
		guard
			let nc = self.childViewControllers.first as? UINavigationController,
			let vc = nc.childViewControllers.first as? NoteEditViewController else {
				fatalError()
		}
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

}

extension MainSplitViewController {

	func createNote() {
		noteTimelineViewController.handleCreatingNoteShortcut()
	}

	func displayNote(noteIdentifier: String) {
		noteTimelineViewController.handleDisplayNoteShortcut(noteIdentifier: noteIdentifier)
	}

	func focusOnSearchBar() {
		noteTimelineViewController.becomeFirstResponder()
		noteTimelineViewController.handleFocusOnSearchBarShortcut()
	}

}
