//
//  FetchedResultTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultTableViewController: UITableViewController, ManagedObjectContextSettable {

	var managedObjectContext: NSManagedObjectContext!
	var fetchedResultsController: NSFetchedResultsController!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupFetchedResultController()
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

	override func viewWillAppear(animated: Bool) {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
		}
		fetchData()
		super.viewWillAppear(animated)
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

	func objectAt<T>(indexPath: NSIndexPath) -> T {
		guard let object = fetchedResultsController.objectAtIndexPath(indexPath) as? T else {
			fatalError("Can't find object at indexPath \(indexPath)")
		}
		return object
	}
}

// MARK: NSFetchedResultsControllerDelegate

extension FetchedResultTableViewController: NSFetchedResultsControllerDelegate {

	func controller(
		controller: NSFetchedResultsController,
		didChangeObject anObject: AnyObject,
		atIndexPath indexPath: NSIndexPath?,
		forChangeType type: NSFetchedResultsChangeType,
		newIndexPath: NSIndexPath?) {
			switch type {
			case .Delete:
				tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
				break
			case .Insert:
				tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
				break
			case .Move:
				tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
				break
			case .Update:
				tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
				break
			}
	}

	func controller(controller: NSFetchedResultsController,
		didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
		atIndex sectionIndex: Int,
		forChangeType type: NSFetchedResultsChangeType) {
			switch type {
			case .Insert:
				tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
				break
			case .Delete:
				tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
				break
			default:
				return
			}
	}

	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}

}
