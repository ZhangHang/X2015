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

	private var storedTheme: Theme = .Default

	private(set) var currentTheme: Theme = .Default {

		didSet {
			UIApplication.sharedApplication().statusBarStyle = .LightContent

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

	private var automaticallyAdjustsTheme: Bool = false

	private var registeredClass: [AppearanceAdaptable.Type] = []

	var minimumBrightness: CGFloat = 0.35

	init() {
		NSNotificationCenter
			.defaultCenter()
			.addObserver(
				self,
				selector: "handleBrightnessChangeNotification:",
				name: UIScreenBrightnessDidChangeNotification,
				object: nil)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

}

extension ThemeManager {

	func synchronizeWithSettings() {
		let settings = NSUserDefaults.standardUserDefaults()
		storedTheme = settings.currentTheme
		automaticallyAdjustsTheme = settings.automaticallyAdjustsTheme
		updateCurrentThemeIfNeeded(true)
	}

	func register(appearanceAdaptableClass: AppearanceAdaptable.Type) {
		registeredClass.append(appearanceAdaptableClass)
	}

	private var themeByBrightness: Theme {
		if UIScreen.mainScreen().brightness <=  minimumBrightness {
			return .Night
		} else {
			return .Default
		}
	}

	@objc
	private func handleBrightnessChangeNotification(note: NSNotification) {
		updateCurrentThemeIfNeeded()
	}

	private func updateCurrentThemeIfNeeded(forceUpdate: Bool = false) {
		if automaticallyAdjustsTheme {
			if themeByBrightness != currentTheme || forceUpdate {
				currentTheme = themeByBrightness
			}
		} else {
			if storedTheme != currentTheme || forceUpdate {
				currentTheme = storedTheme
			}
		}
	}

}
