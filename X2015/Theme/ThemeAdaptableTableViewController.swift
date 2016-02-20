//
//  ThemeAdaptableTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class ThemeAdaptableTableViewController: UITableViewController, ThemeAdaptable {

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

	override func tableView(tableView: UITableView,
		willDisplayCell cell: UITableViewCell,
		forRowAtIndexPath indexPath: NSIndexPath) {
			updateCellThemeInterface(cell, theme: currentTheme)
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
			for cell in tableView.visibleCells {
				updateCellThemeInterface(cell, theme: theme)
			}
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

	/**
	Called when cell needs update its theme interface.
	Override this method to implement custom behavior

	- parameter cell:  cell that needs update
	- parameter theme: current theme
	*/
	func updateCellThemeInterface(cell: UITableViewCell, theme: Theme) {
		if let cell = cell as? ThemeAdaptable {
			cell.configureTheme(currentTheme)
		}
	}

}
