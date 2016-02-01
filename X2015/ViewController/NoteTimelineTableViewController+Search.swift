//
//  NoteTimelineTableViewController+Search.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

extension NoteTimelineTableViewController {

	func setupSearchController() {
		noteSearchTableViewController = { [unowned self] in
			let viewController = NoteSearchTableViewController()
			viewController.managedObjectContext = self.managedObjectContext
			viewController.delegate = self

			return viewController
		}()
		searchController = { [unowned self] in
			let controller = UISearchController(searchResultsController: $0)
			controller.searchResultsUpdater = self
			controller.dimsBackgroundDuringPresentation = true
			controller.hidesNavigationBarDuringPresentation = true
			controller.delegate = self

			let statusBarHeight: CGFloat = 20.0
			let searchBarHeight: CGFloat = CGRectGetHeight(controller.searchBar.bounds)
			$0.tableView.contentInset.top = searchBarHeight + statusBarHeight
			$0.automaticallyAdjustsScrollViewInsets = false

			return controller
		}(noteSearchTableViewController)

		tableView.tableHeaderView = searchController.searchBar
	}

}

extension NoteTimelineTableViewController: NoteSearchTableViewControllerDelegate {

	func noteSearchTableViewController(
		controller: NoteSearchTableViewController,
		didSelectNoteID noteObjectID: NSManagedObjectID) {

			guard let noteFromEditVC = managedObjectContext.objectWithID(noteObjectID)
				as? Note else {
				fatalError("can't find note object passed from edtor view controller")
			}

			self.selectedNote = noteFromEditVC
			searchController.dismissViewControllerAnimated(true) { [unowned self] () -> Void in
				self.performSegueWithIdentifier(
					NoteEditViewController.Storyboard.SegueIdentifierEdit,
					sender: self)
			}
	}

}

extension NoteTimelineTableViewController: UISearchResultsUpdating {

	func updateSearchResultsForSearchController(searchController: UISearchController) {
		noteSearchTableViewController.search(searchController.searchBar.text)
	}

}

extension NoteTimelineTableViewController: UISearchControllerDelegate {

	func willPresentSearchController(searchController: UISearchController) {}

	func didPresentSearchController(searchController: UISearchController) {}

	func willDismissSearchController(searchController: UISearchController) {}

	func didDismissSearchController(searchController: UISearchController) {
		searchController.searchBar.text = nil
	}

}
