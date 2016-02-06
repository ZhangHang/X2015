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

final class TodayTableViewController: UITableViewController {

	private var managedObjectContext: NSManagedObjectContext {
		return managedObjectContextBridge.managedObjectContext
	}
	private let managedObjectContextBridge = ManagedObjectContextBridge(policies: [.Receive])
	private var notes: [Note] = [Note]()
	private var noteFetchRequest: NSFetchRequest = {
		let fetchRequest = NSFetchRequest(entityName: Note.entityName)
		fetchRequest.sortDescriptors = Note.defaultSortDescriptors
		fetchRequest.fetchLimit = 3
		return fetchRequest
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		preferredContentSize = CGSize(width: preferredContentSize.width, height: 60)
		tableView.separatorEffect = UIVibrancyEffect.notificationCenterVibrancyEffect()
		tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

		NSNotificationCenter
			.defaultCenter()
			.addObserverForName(NSManagedObjectContextDidSaveNotification,
				object: nil,
				queue: NSOperationQueue.mainQueue()) { (note) -> Void in
					self.updateInterface()
		}
		updateInterface()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		updateInterface()
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
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

}


extension TodayTableViewController: NCWidgetProviding {

	func widgetMarginInsetsForProposedMarginInsets(
		defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
			return UIEdgeInsetsZero
	}

	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
		updateInterface()
		if notes.count == 0 {
			completionHandler(.NoData)
		} else {
			completionHandler(.NewData)
		}
	}

}


extension TodayTableViewController {

	func updateInterface() {
		do {
			//swiftlint:disable force_cast
			notes = try managedObjectContext.executeFetchRequest(noteFetchRequest) as! [Note]
			//swiftlint:enable force_cast
			tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
			preferredContentSize = tableView.contentSize
		} catch let e {
			debugPrint("fetch error \(e)")
		}
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
		let note: Note = notes[indexPath.row]
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
