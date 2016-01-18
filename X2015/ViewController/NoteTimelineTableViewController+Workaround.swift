//
//  NoteTimelineTableViewController+Workaround.swift
//  X2015
//
//  Created by Hang Zhang on 1/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

/*
 * workaround for http://stackoverflow.com/questions/34694178/using-3d-touch-with-storyboards-peek-and-pop
 */
extension NoteTimelineTableViewController {

	override func tableView(
		tableView: UITableView,
		shouldHighlightRowAtIndexPath
		indexPath: NSIndexPath) -> Bool {
			selectedIndexPath = indexPath
			return true
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedIndexPath = indexPath
	}

	override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		selectedIndexPath = nil
	}

}
