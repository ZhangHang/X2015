//
//  SettingsTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	private enum CellType {

		case UnlockByTouchID
		case DarkMode

		var section: Int {
			switch self {
			case .UnlockByTouchID:
				return 0
			case .DarkMode:
				return 0
			}
		}

		var row: Int {
			switch self {
			case .UnlockByTouchID:
				return 0
			case .DarkMode:
				return 1
			}
		}

		var indexPath: NSIndexPath {
			return NSIndexPath(forRow: row, inSection: section)
		}

	}

	private let settings = Settings()

	@IBOutlet weak var unlockByTouchIDSwitch: UISwitch!
	@IBOutlet weak var unlockByTouchCellTitleLabel: UILabel!

	@IBOutlet weak var darkModeSwitch: UISwitch!

	override func viewWillAppear(animated: Bool) {
		updateUnlockByTouchIDCell()
		super.viewWillAppear(animated)
	}

	override func tableView(
		tableView: UITableView,
		willDisplayCell cell: UITableViewCell,
		forRowAtIndexPath indexPath: NSIndexPath) {
			switch indexPath {
			case CellType.UnlockByTouchID.indexPath:
				updateUnlockByTouchIDCell()
			case CellType.DarkMode.indexPath:
				updateDarkModeCell()
			default:
				break
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

	private func updateDarkModeCell() {
		darkModeSwitch.on = ThemeManager.sharedInstance.currentTheme == .Dark
	}

	@IBAction func handleDarkModeSwitchValueChanged(sender: UISwitch) {
		let theme: Theme = sender.on ? .Dark : .Bright
		ThemeManager.sharedInstance.currentTheme = theme
		settings.theme = theme
		settings.synchronize()
	}
}
