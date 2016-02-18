//
//  NoteEditViewController+Action.swift
//  X2015
//
//  Created by Hang Zhang on 2/2/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	/**
	Share a note to third-party app

	- parameter sender: a trigger button
	*/
	@IBAction func handleActionButtonPressed(sender: UIBarButtonItem) {
		let activityViewController = UIActivityViewController(
			activityItems: [noteManager!.noteContent!],
			applicationActivities: nil)
		activityViewController.popoverPresentationController?.barButtonItem = sender
		presentViewController(activityViewController, animated: true, completion: nil)
	}

}
