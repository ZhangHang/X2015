//
//  ThemeAdaptableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class ThemeAdaptableViewController: UIViewController, ThemeAdaptable {

	private var needsUpdateTheme: Bool = true

	var currentTheme: Theme {
		return ThemeManager.sharedInstance.currentTheme
	}

	/// Duration of theme transition
	var themeTransitionDuration: NSTimeInterval = 0.25

	override func viewWillAppear(animated: Bool) {
		if needsUpdateTheme {
			updateThemeInterfaceHelper(currentTheme, animated: false)
			needsUpdateTheme = false
		}
		super.viewWillAppear(animated)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "handleThemeChangeNotification",
			name: ThemeChangeNotification,
			object: nil)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: ThemeChangeNotification,
			object: nil)
	}

	@objc
	private func handleThemeChangeNotification() {
		if isViewLoaded() {
			updateThemeInterfaceHelper(currentTheme, animated: true)
		} else {
			needsUpdateTheme = true
		}
	}

	/**
	Called when currentTheme has changed or view is about to appearing and `needsUpdateTheme` is true.
	Override this method to implement custom behavior

	- parameter theme:    current theme
	- parameter animated: Default is true
	*/
	func updateThemeInterface(theme: Theme, animated: Bool = true) {
		func updateInterface() {
			configureTheme(theme)
		}
		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: updateInterface)
		} else {
			updateInterface()
		}
	}

	func willUpdateThemeInterface(theme: Theme) {}

	func didUpdateThemeInterface(theme: Theme) {}

	func updateThemeInterfaceHelper(theme: Theme, animated: Bool = true) {
		willUpdateThemeInterface(theme)
		updateThemeInterface(theme, animated: animated)
		didUpdateThemeInterface(theme)
	}

}
