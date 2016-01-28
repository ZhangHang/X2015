//
//  UIViewController+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UINavigationController: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UIHelper.setupNavigationBarStyle(
				UIColor.x2015_BlueColor(),
				backgroundColor: UIColor.whiteColor(),
				barStyle: .Black)
		case .Dark:
			UIHelper.setupNavigationBarStyle(
				UIColor.blackColor(),
				backgroundColor: UIColor.whiteColor(),
				barStyle: .Black)
		}
	}
}

extension UINavigationController: ThemeAdaptable {

	func configureTheme(theme: Theme) -> Void {
		switch theme {
		case .Bright:
			navigationBar.barTintColor = UIColor.x2015_BlueColor()
			navigationBar.tintColor = UIColor.whiteColor()
			navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		case .Dark:
			navigationBar.barTintColor = UIColor.blackColor()
			navigationBar.tintColor = UIColor.whiteColor()
			navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		}
	}

}

extension ThemeAdaptable where Self: UIViewController {

	func configureTheme(theme: Theme) -> Void {
		navigationController?.configureTheme(theme)
		switch theme {
		case .Bright:
			view.backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			view.backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}

extension ThemeAdaptable where Self: UITableViewController {

	func configureTheme(theme: Theme) {
		navigationController?.configureTheme(theme)
		let grouped = tableView.style == .Grouped
		switch theme {
		case .Bright:
			if grouped {
				tableView.backgroundColor = UIColor.bright_tableViewBackgroundColor()
			} else {
				tableView.backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
			}
			tableView.separatorColor = UIColor.lightGrayColor()
		case .Dark:
			tableView.backgroundColor = UIColor.dark_tableViewBackgroundColor()
			tableView.separatorColor = UIColor.darkGrayColor()
		}
	}

}
