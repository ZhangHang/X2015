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
		fetchData()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter
			.defaultCenter()
			.addObserverForName(themeChangeNotification,
				object: nil,
				queue: NSOperationQueue.mainQueue()) {
					[unowned self] (_) -> Void in
			self.updateThemeInterface()
		}
		updateThemeInterface()
	}

	override func viewDidDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: themeChangeNotification, object: nil)
		super.viewDidDisappear(animated)
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
		if tableView.numberOfSections == 1
			&& tableView.numberOfRowsInSection(0) == 0 {
				debugPrint("Workaround")
				tableView.reloadData()
		}
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
				tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
			case .Move:
				tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
				tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
			}
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}

}

extension FetchedResultTableViewController: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Bright:
			tableView.separatorColor = UIColor.lightGrayColor()
		case .Dark:
			tableView.separatorColor = UIColor.darkGrayColor()
		}
	}

}
