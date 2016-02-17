//
//  FetchedResultTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultTableViewController: ThemeAdaptableTableViewController, ManagedObjectContextSettable {

	var managedObjectContext: NSManagedObjectContext!
	var fetchedResultsController: NSFetchedResultsController!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupFetchedResultController()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		fetchData()
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

}

extension FetchedResultTableViewController {

	// Override point
	func setupFetchedResultController() {
		fatalError("Override this method to configure fetchedResultController")
	}

	func fetchData() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError()
		}
	}

	func objectAt<T where T:NSManagedObject>(indexPath: NSIndexPath) -> T {
		guard let object = fetchedResultsController.objectAtIndexPath(indexPath) as? T else {
			fatalError("Can't find object at indexPath \(indexPath)")
		}
		return object
	}

}

// MARK: NSFetchedResultsControllerDelegate

extension FetchedResultTableViewController: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		// WORKAROUND BEGIN
		if tableView.numberOfSections == 1
			&& tableView.numberOfRowsInSection(0) == 0 {
				debugPrint("Workaround")
				tableView.reloadData()
		}
		// WORKAROUND END
		tableView.beginUpdates()
	}

	func controller(controller: NSFetchedResultsController,
		didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
		atIndex sectionIndex: Int,
		forChangeType type: NSFetchedResultsChangeType) {
			switch type {
			case .Insert:
				tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
			case .Delete:
				tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
			default:
				return
			}
	}

	func controller(controller: NSFetchedResultsController,
		didChangeObject anObject: AnyObject,
		atIndexPath indexPath: NSIndexPath?,
		forChangeType type: NSFetchedResultsChangeType,
		newIndexPath: NSIndexPath?) {
			switch type {
			case .Insert:
				tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
			case .Delete:
				tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
			case .Update:
				if let cell = tableView.cellForRowAtIndexPath(indexPath!) {
					configureCell(cell, atIndexPath: indexPath!)
				}
			case .Move:
				tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
				tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
			}
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}

	func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		fatalError("override requried")
	}

}
