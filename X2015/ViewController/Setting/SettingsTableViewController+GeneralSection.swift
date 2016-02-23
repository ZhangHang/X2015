//
//  SettingsTableViewController+GeneralSection.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension SettingsTableViewController {

	enum GeneralSection: Int, TableViewSection {
		case UnlockByTouchID = 0

		//swiftlint:disable variable_name
		//swiftlint:disable type_name
		case COUNT_USE_ONLY_DO_NOT_USE
		static var numberOfRow: Int {
			return GeneralSection.COUNT_USE_ONLY_DO_NOT_USE.rawValue
		}
		//swiftlint:enable variable_name
		//swiftlint:enable type_name

		static var headerText: String? {
			return NSLocalizedString("General", comment: "")
		}

		static var footerText: String? {
			return nil
		}

		var title: String {
			switch self {
			case .UnlockByTouchID:
				return NSLocalizedString("Touch ID", comment: "")
			default:
				fatalError()
			}
		}
	}

	func cellForGeneralSectionAtRow(row: Int) -> UITableViewCell {
		guard let cellType = GeneralSection(rawValue: row) else { fatalError() }

		func touchIDCell() -> SettingSwitchTableViewCell {
			let cell = dequeueSettingSwitchCell()
			cell.configure(
				NSLocalizedString("Touch ID", comment: ""),
				switchOn: NSUserDefaults.standardUserDefaults().unlockByTouchID,
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
				NSUserDefaults.standardUserDefaults().unlockByTouchID = sender.on
				guard NSUserDefaults.standardUserDefaults().synchronize() else {
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
