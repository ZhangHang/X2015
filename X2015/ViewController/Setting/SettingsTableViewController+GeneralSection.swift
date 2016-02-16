//
//  SettingsTableViewController+GeneralSection.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension SettingsTableViewController {

	func cellForGeneralSectionAtRow(row: Int) -> UITableViewCell {
		guard let cellType = GeneralSection(rawValue: row) else { fatalError() }

		func touchIDCell() -> SettingSwitchTableViewCell {
			let cell = dequeueSettingSwitchCell()
			cell.configure(
				NSLocalizedString("Touch ID", comment: ""),
				switchOn: settings.unlockByTouchID,
				switchTarget: self,
				switchSelector: "handleUnlockByTouchIDSwitchValueChanged:",
				enabled: TouchIDHelper.hasTouchID)
			return cell
		}

		switch cellType {
		case .UnlockByTouchID:
			return touchIDCell()
		default:
			fatalError()
		}
	}

	@objc
	private func handleUnlockByTouchIDSwitchValueChanged(sender: UISwitch) {
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
