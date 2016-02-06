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
		let component = NSURLComponents()
		component.scheme = "x2015"
		component.host = "note"
		component.query = "identifier=\(notes[indexPath.row].identifier)"
		guard let url = component.URL else {
			fatalError()
		}
		extensionContext?.openURL(url, completionHandler: nil)
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
			tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
			preferredContentSize = tableView.contentSize
		} catch let e {
			debugPrint("fetch error \(e)")
		}
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
		cell.contentView.backgroundColor = UIColor(white: 0, alpha: 0.1)
		//Workaround end
	}

}

extension TodayTableViewController {

	@objc
	@IBAction func handleAddButtonPressed(sender: UIButton) {
		let component = NSURLComponents()
		component.scheme = "x2015"
		component.host = "note"
		component.path = "/new"
		guard let url = component.URL else {
			fatalError()
		}
		extensionContext?.openURL(url, completionHandler: nil)
	}

}
