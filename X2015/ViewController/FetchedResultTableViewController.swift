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
	var fetchedResultController: NSFetchedResultsController!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupFetchedResultController()
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultController.sections?[section].objects?.count ?? 0
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return fetchedResultController.sections?.count ?? 0
	}

	override func viewWillAppear(animated: Bool) {
		fetchData()
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
		}
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
			try fetchedResultController.performFetch()
		} catch {
			fatalError()
		}
	}

	func objectAt<T>(indexPath: NSIndexPath) -> T {
		guard let object = fetchedResultController.objectAtIndexPath(indexPath) as? T else {
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

	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}

}
