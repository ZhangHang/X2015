//
//  NoteEditViewController+Action.swift
//  X2015
//
//  Created by Hang Zhang on 2/2/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	@IBAction func handleActionButtonPressed(sender: UIBarButtonItem) {
		let activityViewController = UIActivityViewController(
			activityItems: [noteUpdater!.noteContent!],
			applicationActivities: nil)
		activityViewController.popoverPresentationController?.barButtonItem = sender
		presentViewController(activityViewController, animated: true, completion: nil)
	}

}
