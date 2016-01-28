//
//  ThemeAdaptableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class ThemeAdaptableViewController: UIViewController, ThemeAdaptable {

	var currentTheme: Theme {
		return ThemeManager.sharedInstance.currentTheme
	}

	override func viewWillAppear(animated: Bool) {
		updateThemeInterfaceHelper()
		super.viewWillAppear(animated)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "updateThemeInterfaceHelper",
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
	private func updateThemeInterfaceHelper() {
		updateThemeInterface(currentTheme)
	}

	func updateThemeInterface(theme: Theme) {
		configureTheme(theme)
	}

}
