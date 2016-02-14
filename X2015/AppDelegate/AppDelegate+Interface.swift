//
//  AppDelegate+Interface.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension AppDelegate {

	func configureInterface() {
		ThemeManager.sharedInstance.register([
			UITableView.self,
			UITextView.self,
			UIWindow.self,
			UISearchBar.self,
			UITextField.self,
			UIBarButtonItem.self,
			UINavigationBar.self,
			UINavigationController.self])
		ThemeManager.sharedInstance.restoreFromSettings()
	}

}

extension AppDelegate: UISplitViewControllerDelegate {

	func setupControllers() {
		guard
			let splitViewController = window!.rootViewController as? UISplitViewController,
			let masterNavigationController = splitViewController.childViewControllers.first,
			let noteTimelineViewController = masterNavigationController.childViewControllers.first
				as? NoteTimelineTableViewController else {
				fatalError()
		}

		splitViewController.delegate = self
		noteTimelineViewController.managedObjectContext = managedObjectContext
	}

	func splitViewController(splitViewController: UISplitViewController,
		collapseSecondaryViewController secondaryViewController: UIViewController,
		ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
			guard
				let sc = splitViewController as? MainSplitViewController,
				let vc = sc.noteEditViewController else {
				fatalError()
			}

			switch vc.noteActionMode {
			case .Empty:
				return false
			default:
				return true
			}
	}

}
