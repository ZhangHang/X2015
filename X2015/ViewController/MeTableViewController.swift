//
//  MeTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {

	enum Cell {

		case ExportNote
		case UnlockByTouchID

		var section: Int {
			switch self {
			case .ExportNote:
				return 0
			case .UnlockByTouchID:
				return 1
			}
		}

		var row: Int {
			switch self {
			case .ExportNote:
				return 0
			case .UnlockByTouchID:
				return 0
			}
		}

		var indexPath: NSIndexPath {
			return NSIndexPath(forRow: row, inSection: section)
		}

	}

	private let settings = Settings()

	@IBOutlet weak var unlockByTouchIDSwitch: UISwitch!
	@IBOutlet weak var unlockByTouchCellTitleLabel: UILabel!

	override func viewWillAppear(animated: Bool) {
		updateUnlockByTouchIDCell()
		super.viewWillAppear(animated)
	}

}

extension MeTableViewController {

	override func tableView(
		tableView: UITableView,
		willDisplayCell cell: UITableViewCell,
		forRowAtIndexPath indexPath: NSIndexPath) {
			if indexPath == Cell.UnlockByTouchID.indexPath {
				updateUnlockByTouchIDCell()
			}
	}

	private func updateUnlockByTouchIDCell() {
		let hasTouchID = TouchIDHelper.hasTouchID
		unlockByTouchCellTitleLabel.enabled = hasTouchID
		unlockByTouchIDSwitch.enabled = hasTouchID
		unlockByTouchIDSwitch.on = settings.unlockByTouchID
	}

	@IBAction func handleUnlockByTouchIDSwitchValueChanged(sender: UISwitch) {
		TouchIDHelper.auth(
			NSLocalizedString("Use Touch ID to Unlock", comment: ""),
				successHandler: { () -> Void in
					self.settings.unlockByTouchID = sender.on
					guard self.settings.synchronize() else {
						fatalError("Setting save failed")
					}
			},
				errorHandler: { (errorMessage) -> Void in
					sender.setOn(!sender.on, animated: true)
					if errorMessage?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
						let alertView = UIAlertController(
							title: NSLocalizedString("Error", comment: ""),
							message: errorMessage,
							preferredStyle:.Alert)
						let okAction = UIAlertAction(
							title: NSLocalizedString("OK", comment: ""),
							style: .Default,
							handler: nil)
						alertView.addAction(okAction)
						self.presentViewController(alertView, animated: true, completion: nil)
					}
		})
	}

}
