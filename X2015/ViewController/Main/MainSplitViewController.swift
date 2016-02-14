//
//  MainSplitViewController.swift
//  X2015
//
//  Created by Hang Zhang on 2/7/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

final class MainSplitViewController: UISplitViewController, ManagedObjectContextSettable {

	var managedObjectContext: NSManagedObjectContext! {
		didSet {
			guard let timelineVC = noteTimelineViewController else {
				fatalError()
			}
			timelineVC.managedObjectContext = managedObjectContext
		}
	}

	var noteTimelineViewController: NoteTimelineTableViewController? {
		guard
			let nc = childViewControllers.first as? UINavigationController,
			let vc = nc.childViewControllers.first as? NoteTimelineTableViewController else {
				return nil
		}
		return vc
	}

	var noteEditViewController: NoteEditViewController? {
		if childViewControllers.count == 1 {
			guard
				let mnc = childViewControllers.last as? UINavigationController,
				let dnc = mnc.childViewControllers.last as? UINavigationController,
				let vc = dnc.topViewController as? NoteEditViewController else {
					return nil
			}
			return vc
		}

		if childViewControllers.count == 2 {
			guard
				let nc = childViewControllers.last as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController else {
					return nil
			}
			return vc
		}

		debugPrint("can't find note edit controller")
		return nil
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}

}

extension MainSplitViewController {

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	override func prefersStatusBarHidden() -> Bool {
		return false
	}

	override func childViewControllerForStatusBarHidden() -> UIViewController? {
		return noteEditViewController
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
