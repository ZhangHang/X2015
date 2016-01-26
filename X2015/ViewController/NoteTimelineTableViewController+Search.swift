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
		noteSearchTableViewController = NoteSearchTableViewController()
		noteSearchTableViewController.managedObjectContext = managedObjectContext
		noteSearchTableViewController.delegate = self
		searchController = UISearchController(searchResultsController: noteSearchTableViewController)
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = true
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.delegate = self
		tableView.tableHeaderView = searchController.searchBar

		let statusBarHeight: CGFloat = 20.0
		let searchBarHeight: CGFloat = CGRectGetHeight(searchController.searchBar.bounds)
		noteSearchTableViewController.tableView.contentInset.top = searchBarHeight + statusBarHeight
		noteSearchTableViewController.automaticallyAdjustsScrollViewInsets = false
	}

}

extension NoteTimelineTableViewController: NoteSearchTableViewControllerDelegate {

	func noteSearchTableViewController(
		controller: NoteSearchTableViewController,
		didSelectNoteID noteObjectID: NSManagedObjectID) {
			self.selectedNoteObjectID = noteObjectID
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

	func willPresentSearchController(searchController: UISearchController) {

	}

	func didPresentSearchController(searchController: UISearchController) {

	}

	func willDismissSearchController(searchController: UISearchController) {

	}

	func didDismissSearchController(searchController: UISearchController) {
		searchController.searchBar.text = nil
	}

}
