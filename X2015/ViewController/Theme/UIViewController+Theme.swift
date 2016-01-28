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
		case .Defualt:
			UIHelper.setupNavigationBarStyle(
				UIColor.x2015_BlueColor(),
				backgroundColor: UIColor.whiteColor(),
				barStyle: .Black)
		case .Night:
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
		case .Defualt:
			navigationBar.barTintColor = UIColor.x2015_BlueColor()
			navigationBar.tintColor = UIColor.whiteColor()
			navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		case .Night:
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
		case .Defualt:
			view.backgroundColor = UIColor.defualt_ViewControllerBackgroundColor()
		case .Night:
			view.backgroundColor = UIColor.night_ViewControllerBackgroundColor()
		}
	}

}

extension ThemeAdaptable where Self: UITableViewController {

	func configureTheme(theme: Theme) {
		navigationController?.configureTheme(theme)
		let grouped = tableView.style == .Grouped
		switch theme {
		case .Defualt:
			if grouped {
				tableView.backgroundColor = UIColor.defualt_tableViewBackgroundColor()
			} else {
				tableView.backgroundColor = UIColor.defualt_ViewControllerBackgroundColor()
			}
			tableView.separatorColor = UIColor.lightGrayColor()
			view.backgroundColor = UIColor.defualt_ViewControllerBackgroundColor()
		case .Night:
			tableView.backgroundColor = UIColor.night_tableViewBackgroundColor()
			tableView.separatorColor = UIColor.darkGrayColor()
			view.backgroundColor = UIColor.night_ViewControllerBackgroundColor()
		}
	}

}
