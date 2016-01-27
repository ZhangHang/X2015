//
//  SettingsTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class SettingsTableViewController: ThemeAdaptableTableViewController {

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

}

extension SettingsTableViewController {

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			guard let cell = tableView.dequeueReusableCellWithIdentifier(SettingSwitchTableViewCell.reuseIdentifier)
				as? SettingSwitchTableViewCell else {
					fatalError()
			}
			switch indexPath {
			case CellType.DarkMode.indexPath:
				configureForDarkModeCell(cell)
			case CellType.UnlockByTouchID.indexPath:
				configureTouchIDCell(cell)
			default:
				fatalError()
			}
			return cell
	}

	private func configureTouchIDCell(cell: SettingSwitchTableViewCell) {
		let hasTouchID = TouchIDHelper.hasTouchID
		cell.settingTitleLabel.enabled = hasTouchID
		cell.settingSwitch.enabled = hasTouchID

		cell.settingTitleLabel.text = NSLocalizedString("Touch ID", comment: "")
		cell.settingSwitch.on = settings.unlockByTouchID
		cell.settingSwitch.removeTarget(self, action: nil, forControlEvents: .ValueChanged)
		cell.settingSwitch.addTarget(self,
			action: "handleUnlockByTouchIDSwitchValueChanged:",
			forControlEvents: .ValueChanged)
		cell.updateThemeInterface()
	}

	private func configureForDarkModeCell(cell: SettingSwitchTableViewCell) {
		cell.settingTitleLabel.text = NSLocalizedString("Dark Mode", comment: "")
		cell.settingSwitch.removeTarget(self, action: nil, forControlEvents: .ValueChanged)
		cell.settingSwitch.on = ThemeManager.sharedInstance.currentTheme == .Dark
		cell.settingSwitch.addTarget(self,
			action: "handleDarkModeSwitchValueChanged:",
			forControlEvents: .ValueChanged)
		cell.updateThemeInterface()
	}


	func handleUnlockByTouchIDSwitchValueChanged(sender: UISwitch) {
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


	func handleDarkModeSwitchValueChanged(sender: UISwitch) {
		let theme: Theme = sender.on ? .Dark : .Bright
		ThemeManager.sharedInstance.currentTheme = theme
		settings.theme = theme
		settings.synchronize()
		updateThemeInterface()
	}

}
