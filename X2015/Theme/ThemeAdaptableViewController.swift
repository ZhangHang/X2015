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

	var themeTransitionDuration: NSTimeInterval = 0.25

	override func viewWillAppear(animated: Bool) {
		if needsUpdateTheme {
			updateThemeInterface(currentTheme, animated: false)
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
			updateThemeInterface(currentTheme, animated: true)
		}

		needsUpdateTheme = true
	}

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

}
