//
//  NoteEditViewController+Navigation.swift
//  X2015
//
//  Created by Hang Zhang on 2/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier {
		case NotePreviewViewController.SegueIdentifier.Present?:
			guard
				let viewController = segue.destinationViewController as? NotePreviewViewController,
				let noteContent = noteManager?.noteContent else {
					fatalError()
			}
			viewController.noteContent = noteContent
		default:
			return
		}
	}

}
