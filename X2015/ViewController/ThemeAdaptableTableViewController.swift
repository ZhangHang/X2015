//
//  ThemeAdaptableTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class ThemeAdaptableTableViewController: UITableViewController, ThemeAdaptable {

	var currentTheme: Theme {
		return ThemeManager.sharedInstance.currentTheme
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		updateThemeInterfaceHelper()
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

	override func tableView(tableView: UITableView,
		willDisplayCell cell: UITableViewCell,
		forRowAtIndexPath indexPath: NSIndexPath) {
			if let cell = cell as? ThemeAdaptable {
				cell.configureTheme(currentTheme)
			}
	}

	@objc
	private func updateThemeInterfaceHelper() {
		updateThemeInterface(currentTheme)
	}

	func updateThemeInterface(theme: Theme) {
		configureTheme(theme)
		for cell in tableView.visibleCells {
			if let cell = cell as? ThemeAdaptable {
				cell.configureTheme(theme)
			}
			updateVisiableCellThemeInterface(cell, theme: theme)
		}
	}

	func updateVisiableCellThemeInterface<CellType: UITableViewCell>(cell: CellType, theme: Theme) {

	}
}
