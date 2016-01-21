//
//  RootTabBarController.swift
//  X2015
//
//  Created by Hang Zhang on 1/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

final class RootTabBarController: UITabBarController, ManagedObjectContextSettable {

	var managedObjectContext: NSManagedObjectContext!

	var noteTimelineViewController: NoteTimelineTableViewController {
		guard
			let nc = childViewControllers.first as? UINavigationController,
			let vc = nc.childViewControllers.first as? NoteTimelineTableViewController else {
				fatalError("Wrong view controller type found")
		}

		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		noteTimelineViewController.managedObjectContext = managedObjectContext
	}

}

extension RootTabBarController {
	func handleNewNoteShortcut() {
		noteTimelineViewController.handleNewNoteShortcut()
	}
}
