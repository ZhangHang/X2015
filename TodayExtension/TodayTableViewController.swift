//
//  TodayTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 2/2/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import NotificationCenter
import X2015Kit

let cellReuseIdentifier = "Cell"

final class TodayTableViewController: UITableViewController, NCWidgetProviding {

	var managedObjectContext: NSManagedObjectContext {
		return managedObjectContextBridge.managedObjectContext
	}
	let managedObjectContextBridge = ManagedObjectContextBridge(policies: [.Receive])
	var fetchedResultsController: NSFetchedResultsController!

	override func viewDidLoad() {
		super.viewDidLoad()

		preferredContentSize = CGSize(width: preferredContentSize.width, height: 60)


		tableView.separatorEffect = UIVibrancyEffect.notificationCenterVibrancyEffect()
		tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

		setupFetchedResultController()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		managedObjectContext.reset()
	}

	func widgetMarginInsetsForProposedMarginInsets(
		defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
			return UIEdgeInsetsZero
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

	override func tableView(tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			guard let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) else {
				fatalError()
			}
			configureCell(cell, atIndexPath: indexPath)
			return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		extensionContext?.openURL(NSURL(string: "file://")!, completionHandler: { (completion) -> Void in

		})
	}

	// MARK: NCWidgetProviding

	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
		// Perform any setup necessary in order to update the view.

		// If an error is encountered, use NCUpdateResult.Failed
		// If there's no update required, use NCUpdateResult.NoData
		// If there's an update, use NCUpdateResult.NewData
		managedObjectContext.mergeChangesFromUserDefaults()
		fetchData()
		if fetchedResultsController.fetchedObjects?.count == 0 {
			completionHandler(.NoData)
		} else {
			preferredContentSize = tableView.contentSize
			completionHandler(.NewData)
		}
	}

}

extension TodayTableViewController {

	func setupFetchedResultController() {
		fetchedResultsController = { [unowned self] in
			let fetchRequest = NSFetchRequest(entityName: Note.entityName)
			fetchRequest.sortDescriptors = Note.defaultSortDescriptors
			fetchRequest.fetchLimit = 3
			let fetchedResultsController = NSFetchedResultsController(
				fetchRequest: fetchRequest,
				managedObjectContext: self.managedObjectContext,
				sectionNameKeyPath: nil,
				cacheName: nil)
			fetchedResultsController.delegate = self
			return fetchedResultsController
			}()

		do {
			try fetchedResultsController.performFetch()
		} catch {

		}
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

extension TodayTableViewController: NSFetchedResultsControllerDelegate {

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
		let note: Note = objectAt(indexPath)
		cell.textLabel?.text = note.title
		cell.detailTextLabel?.text = note.preview

		let effect = UIVibrancyEffect.notificationCenterVibrancyEffect()
		let effectView = UIVisualEffectView(effect: effect)
		effectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]

		effectView.frame = cell.contentView.bounds

		let view = UIView(frame: effectView.bounds)

		view.backgroundColor = tableView.separatorColor
		view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		effectView.contentView.addSubview(view)
		cell.selectedBackgroundView = effectView
		cell.selectionStyle = .Default

		//Workaround begin
		cell.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.001)
		//Workaround end
	}

}
