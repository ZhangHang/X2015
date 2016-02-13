//
//  MainSplitViewController.swift
//  X2015
//
//  Created by Hang Zhang on 2/7/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {

	var noteTimelineViewController: NoteTimelineTableViewController? {
		guard
			let nc = self.childViewControllers.first as? UINavigationController,
			let vc = nc.childViewControllers.first as? NoteTimelineTableViewController else {
				return nil
		}
		return vc
	}
	var noteEditViewController: NoteEditViewController? {
		guard
			let nc = self.childViewControllers.last as? UINavigationController,
			let vc = nc.childViewControllers.first as? NoteEditViewController else {
				return nil
		}
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

}

extension MainSplitViewController {

	func createNote() {
		guard let vc = noteTimelineViewController else {
			fatalError()
		}
		vc.createNote()
	}

	func displayNote(noteIdentifier: String) {
		guard let vc = noteTimelineViewController else {
			fatalError()
		}
		vc.displayNote(noteIdentifier: noteIdentifier)
	}

}
