//
//  ThemeAdaptableTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class ThemeAdaptableTableViewController: UITableViewController, ThemeAdaptable {

	override func viewWillAppear(animated: Bool) {
		updateThemeInterface()
		super.viewWillAppear(animated)
	}

	override func viewDidAppear(animated: Bool) {
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "handleThemeChanged:",
			name: ThemeChangeNotification,
			object: nil)
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: ThemeChangeNotification,
			object: nil)
		super.viewDidDisappear(animated)
	}

	@objc
	private func handleThemeChanged(note: NSNotification) {
	guard let themeValueString = note.userInfo?[ThemeChangeNotificationThemeKey]
			as? String else {
				fatalError()
		}
		guard let targetTheme = Theme(rawValue: themeValueString) else {
			fatalError()
		}

		updateThemeInterface()
		themeChanged(targetTheme)

		for cell in tableView.visibleCells {
			if let cell = cell as? ThemeAdaptable {
				cell.updateThemeInterface()
			}
			cellThemeChanged(targetTheme, cell: cell)
		}
	}

	func themeChanged(toTheme: Theme) {}

	func cellThemeChanged(toTheme: Theme, cell: UITableViewCell) {}

}
