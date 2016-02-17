//
//  UIBarButtonItem+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/2/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UIBarButtonItem: AppearanceAdaptable {

	static func configureThemeAppearance(theme: Theme) {
		appearance().tintColor = UIColor.whiteColor()
		appearanceWhenContainedInInstancesOfClasses([
			UITableViewController.self,
			UIViewController.self,
			UINavigationController.self,
			UISplitViewController.self,
			UINavigationBar.self,
			UIActivityViewController.self
			]).tintColor = UIColor.whiteColor()

		appearanceWhenContainedInInstancesOfClasses([
			UITableViewController.self,
			UIViewController.self,
			UINavigationController.self,
			UISplitViewController.self,
			UINavigationBar.self,
			UIActivityViewController.self
			]).setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
	}

}

extension UIBarButtonItem: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Default:
			tintColor = UIColor.x2015_BlueColor()
		case .Night:
			tintColor = UIColor.whiteColor()
		}
	}

}
