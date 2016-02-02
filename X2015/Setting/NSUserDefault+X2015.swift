//
//  UserDefault+X2015.swift
//  X2015
//
//  Created by Hang Zhang on 2/2/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

private let unlockByTouchIDKey = "unlockByTouchID"
private let themeKey = "theme"
private let automaticallyAdjustsThemeKey = "automaticallyAdjustsTheme"

extension NSUserDefaults {

	var unlockByTouchID: Bool {
		get {
			guard let value = valueForKey(unlockByTouchIDKey) as? Bool else {
				setValue(false, forKey: unlockByTouchIDKey)
				return false
			}
			return value
		}
		set {
			setValue(newValue, forKey: unlockByTouchIDKey)
		}
	}

	var theme: Theme {
		get {
			guard let value = valueForKey(themeKey) as? String else {
				setValue(Theme.Defualt.rawValue, forKey: themeKey)
				return .Defualt
			}
			return Theme(rawValue: value)!
		}
		set {
			setValue(newValue.rawValue, forKey: themeKey)
		}
	}

	var automaticallyAdjustsTheme: Bool {
		get {
			guard let value = valueForKey(automaticallyAdjustsThemeKey) as? Bool else {
				setValue(false, forKey: automaticallyAdjustsThemeKey)
				return false
			}
			return value
		}
		set {
			setValue(newValue, forKey: automaticallyAdjustsThemeKey)
		}
	}

}
