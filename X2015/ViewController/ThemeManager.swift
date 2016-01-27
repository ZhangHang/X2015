//
//  ThemeManager.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

// swiftlint:disable variable_name
public let ThemeChangeNotification: String = "ThemeChangeNotification"
public let ThemeChangeNotificationThemeKey: String = "ThemeChangeNotificationThemeKey"
// swiftlint:enable variable_name

class ThemeManager {

	static let sharedInstance = ThemeManager()

	private var registeredClass: [AppearanceAdaptable.Type] = []

	func synchronizeWithSettings() {
		currentTheme = Settings().theme
	}

	func register(appearanceAdaptableClass: AppearanceAdaptable.Type) {
		registeredClass.append(appearanceAdaptableClass)
	}

	var currentTheme: Theme = .Bright {
		didSet {
			switch currentTheme {
			case .Bright:
				UIApplication.sharedApplication().statusBarStyle = .LightContent
			case .Dark:
				UIApplication.sharedApplication().statusBarStyle = .LightContent
			}
			for adaptable in registeredClass {
				adaptable.configureThemeAppearance(currentTheme)
			}

			NSNotificationCenter
			.defaultCenter()
			.postNotificationName(
				ThemeChangeNotification,
				object: nil,
				userInfo: [ThemeChangeNotificationThemeKey: currentTheme.rawValue])
		}
	}

}

extension ThemeAdaptable {

	func updateThemeInterface() {
		configureTheme(ThemeManager.sharedInstance.currentTheme)
	}

}
