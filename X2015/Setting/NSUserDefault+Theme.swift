//
//  NSUserDefault+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/11/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

private let themeKey = "theme"
private let automaticallyAdjustsThemeKey = "automaticallyAdjustsTheme"

extension NSUserDefaults {

	/// Default is .Defualt theme
	var theme: Theme {
		get {
			guard let value = valueForKey(themeKey) as? String else {
				setValue(Theme.Default.rawValue, forKey: themeKey)
				return .Default
			}
			return Theme(rawValue: value)!
		}
		set {
			setValue(newValue.rawValue, forKey: themeKey)
		}
	}

	/// Default is false
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

extension ThemeManager {

	func synchronizeWithSettings() -> Bool {
		let settings = NSUserDefaults.standardUserDefaults()
		settings.theme = userSelectedTheme
		settings.automaticallyAdjustsTheme = automaticallyAdjustsTheme
		updateCurrentThemeIfNeeded(true)
		return settings.synchronize()
	}

	func restoreFromSettings() {
		let settings = NSUserDefaults.standardUserDefaults()
		userSelectedTheme = settings.theme
		automaticallyAdjustsTheme = settings.automaticallyAdjustsTheme
		updateCurrentThemeIfNeeded(true)
	}

}
