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
		searchController = UISearchController(searchResultsController: noteSearchTableViewController)
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = true
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.searchBar.delegate = self
		tableView.tableHeaderView = searchController.searchBar

		let statusBarHeight: CGFloat = 20.0
		let searchBarHeight: CGFloat = CGRectGetHeight(searchController.searchBar.bounds)
		noteSearchTableViewController.tableView.contentInset.top = searchBarHeight + statusBarHeight
		noteSearchTableViewController.automaticallyAdjustsScrollViewInsets = false
	}

}

extension NoteTimelineTableViewController: UISearchResultsUpdating {

	func updateSearchResultsForSearchController(searchController: UISearchController) {
		noteSearchTableViewController.search(searchController.searchBar.text)
	}

}

extension NoteTimelineTableViewController: UISearchBarDelegate {

}
