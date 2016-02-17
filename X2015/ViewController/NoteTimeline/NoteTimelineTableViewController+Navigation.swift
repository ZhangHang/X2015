//
//  NoteTimelineTableViewController+Navigation.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

extension NoteTimelineTableViewController {

	/**
	Pop back to timeline controller

	- parameter completion: called if success
	- parameter workaround: called if success
							and needs yout to manually push view controller
	*/
	func backToTimeline(
		@noescape completion: () -> Void,
		@noescape workaround: () -> Void ) {
			if let presentedViewController = navigationController?.presentedViewController
				where presentedViewController != self {
					navigationController!.dismissViewControllerAnimated(false, completion: nil)
			}

			// WORKAROUND BEGIN
			if navigationController!.topViewController != self {
				debugPrint("Workaround")
				navigationController!.popToViewController(self, animated: false)
				workaround()
				return
			}
			// WORKAROUND END

			completion()
	}

	@IBAction func insertNewNote(sender: UIBarButtonItem) {
		performSegueWithIdentifier(NoteEditViewController.SegueIdentifier.Create, sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else {
			return
		}

		switch identifier {
		case
			NoteEditViewController.SegueIdentifier.Create,
			NoteEditViewController.SegueIdentifier.CreateWithNoAnimation:
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController else {
					fatalError("Wrong edit-viewcontroller")
			}

			selectedNote = managedObjectContext.insertObject() as Note
			vc.editingMode = .Create(selectedNote!.objectID, managedObjectContext)
		case
			NoteEditViewController.SegueIdentifier.Edit,
			NoteEditViewController.SegueIdentifier.EditWithNoAnimation:
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController,
				let selectedNote = self.selectedNote else {
					fatalError("Wrong edit-viewcontroller")
			}

			vc.editingMode = .Edit(selectedNote.objectID, managedObjectContext)
		case
			NoteEditViewController.SegueIdentifier.Empty:
			break
		default:
			return
		}
	}

}

extension NoteTimelineTableViewController {

	@IBAction func closeSettingsViewController(segue: UIStoryboardSegue) {}

}
