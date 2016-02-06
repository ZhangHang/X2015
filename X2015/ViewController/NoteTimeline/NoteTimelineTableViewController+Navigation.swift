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

	typealias NoteEditVCStoryboard = NoteEditViewController.Storyboard

	func backToTimeline(
		completion: (() -> Void)?,
		workaround: (() -> Void)? ) {
		if let presentedViewController = navigationController?.presentedViewController
			where presentedViewController != self {
				navigationController!.dismissViewControllerAnimated(false, completion: nil)
		}

		// WORKAROUND BEGIN
		if navigationController!.topViewController != self {
			debugPrint("Workaround")
			navigationController!.popToViewController(self, animated: false)
			workaround?()
			return
		}
		// WORKAROUND END

		completion?()
	}

	@IBAction func insertNewNote(sender: UIBarButtonItem) {
		performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierCreate, sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else {
			return
		}

		switch identifier {
		case NoteEditVCStoryboard.SegueIdentifierCreate, NoteEditVCStoryboard.SegueIdentifierCreateWithNoAnimation:
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController else {
					fatalError("Wrong edit-viewcontroller")
			}

			selectedNote = managedObjectContext.insertObject() as Note
			vc.noteActionMode = .Create(selectedNote!.objectID, managedObjectContext)
		case NoteEditVCStoryboard.SegueIdentifierEdit, NoteEditVCStoryboard.SegueIdentifierEditWithNoAnimation:
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController,
				let selectedNote = self.selectedNote else {
					fatalError("Wrong edit-viewcontroller")
			}

			vc.noteActionMode = .Edit(selectedNote.objectID, managedObjectContext)
		case NoteEditVCStoryboard.SegueIdentifierEmpty:
			break
		default:
			return
		}
	}

}

extension NoteTimelineTableViewController {

	@IBAction func closeSettingsViewController(segue: UIStoryboardSegue) {}

}
