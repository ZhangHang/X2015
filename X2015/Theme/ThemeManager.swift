//
//  ThemeManager.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

// swiftlint:disable variable_name
let ThemeChangeNotification: String = "ThemeChangeNotification"
let ThemeChangeNotificationThemeKey: String = "ThemeChangeNotificationThemeKey"
// swiftlint:enable variable_name

final class ThemeManager {

	static let sharedInstance = ThemeManager()

	var userSelectedTheme: Theme = .Default

	private(set) var currentTheme: Theme = .Default {

		didSet {
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

	var automaticallyAdjustsTheme: Bool = false

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

	func register(appearanceAdaptableClasses: [AppearanceAdaptable.Type]) {
		registeredClass.appendContentsOf(appearanceAdaptableClasses)
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
		if automaticallyAdjustsTheme {
			updateCurrentThemeIfNeeded()
		}
	}

	func updateCurrentThemeIfNeeded(forceUpdate: Bool = false) {
		if automaticallyAdjustsTheme {
			if themeByBrightness != currentTheme || forceUpdate {
				currentTheme = themeByBrightness
			}
		} else {
			if userSelectedTheme != currentTheme || forceUpdate {
				currentTheme = userSelectedTheme
			}
		}
	}

}
