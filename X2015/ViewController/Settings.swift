//
//  Settings.swift
//  X2015
//
//  Created by Hang Zhang on 1/19/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class Settings {
	let userDefualt = NSUserDefaults.standardUserDefaults()

	private let unlockByTouchIDKey = "unlockByTouchID"
	var unlockByTouchID: Bool {
		get {
			guard let value = userDefualt.valueForKey(unlockByTouchIDKey) as? Bool else {
				userDefualt.setValue(false, forKey: unlockByTouchIDKey)
				return false
			}
			return value
		}
		set {
			userDefualt.setValue(newValue, forKey: unlockByTouchIDKey)
		}
	}

	private let themeKey = "theme"
	var theme: Theme {
		get {
			guard let value = userDefualt.valueForKey(themeKey) as? String else {
				userDefualt.setValue(Theme.Bright.rawValue, forKey: themeKey)
				return .Bright
			}
			return Theme(rawValue: value)!
		}
		set {
			userDefualt.setValue(newValue.rawValue, forKey: themeKey)
		}
	}

	func synchronize() -> Bool {
		return userDefualt.synchronize()
	}

}
