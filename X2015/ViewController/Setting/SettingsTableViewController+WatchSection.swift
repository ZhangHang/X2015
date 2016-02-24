//
//  SettingsTableViewController+WatchSection.swift
//  X2015
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import WatchConnectivity

extension SettingsTableViewController {

	enum WatchSecion: Int, TableViewSection {

		//swiftlint:disable variable_name
		//swiftlint:disable type_name
		case COUNT_USE_ONLY_DO_NOT_USE = 0
		static var numberOfRow: Int {
			return WatchSecion.COUNT_USE_ONLY_DO_NOT_USE.rawValue
		}
		//swiftlint:enable variable_name
		//swiftlint:enable type_name

		static var headerText: String? {
			return NSLocalizedString("Watch", comment: "")
		}

		static var footerText: String? {
			return nil
		}

		var title: String {
			switch self {
			default:
				fatalError()
			}
		}

		static var visible: Bool {
			if WCSession.isSupported() {
				let session = WCSession.defaultSession()
				session.activateSession()
				if session.watchAppInstalled && session.paired {
					return true
				}
				return false
			}
			return false
		}
	}

	func cellForWatchSectionAtRow(row: Int) -> UITableViewCell {
		fatalError()
	}

}
