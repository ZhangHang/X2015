//
//  BaseUIKitControlThemeExtension.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UILabel: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UILabel.appearance().textColor = UIColor.blackColor()
		case .Dark:
			UILabel.appearance().textColor = UIColor.whiteColor()
		}
	}
}

extension UIWindow: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UIWindow.appearance().tintColor = UIColor.x2015_BlueColor()
			UIWindow.appearance().backgroundColor = UIColor.whiteColor()
		case .Dark:
			UIWindow.appearance().tintColor = UIColor.whiteColor()
			UIWindow.appearance().backgroundColor = UIColor.blackColor()
		}
	}
}

extension UITextView: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UITextView.appearance().textColor = UIColor.bright_MainTextColor()
			UITextView.appearance().backgroundColor = UIColor.clearColor()
		case .Dark:
			UITextView.appearance().backgroundColor = UIColor.dark_MainTextColor()
			UITextView.appearance().backgroundColor = UIColor.clearColor()
		}
	}
}

extension UITableView: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UITableView.appearance().backgroundColor = UIColor.whiteColor()
		case .Dark:
			UITableView.appearance().backgroundColor = UIColor.blackColor()
		}
	}
}

extension UISearchBar: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
//			UISearchBar.appearance().barTintColor = UIColor.whiteColor()
			break
		case .Dark:
//			UISearchBar.appearance().barTintColor = UIColor.blackColor()
			break
		}
	}
}

extension UITextField: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UITextField.appearance().keyboardAppearance = .Light
		case .Dark:
			UITextField.appearance().keyboardAppearance = .Dark
		}
	}
}

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

extension ThemeAdaptable where Self: UIViewController {

	func configureTheme(theme: Theme) -> Void {
		switch theme {
		case .Bright:
			view.backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			view.backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}

extension ThemeAdaptable where Self: UIView {

	func configureTheme(theme: Theme) -> Void {
		switch theme {
		case .Bright:
			backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}


extension AppearanceAdaptable where Self: UITableViewCell {

	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			Self.appearance().backgroundColor = UIColor
				.bright_tableViewCellBackgroundColor()
		case .Dark:
			Self.appearance().backgroundColor = UIColor
				.dark_tableViewCellBackgroundColor()
		}
	}

}

extension ThemeAdaptable where Self: UITableViewCell {

	func configureTheme(theme: Theme) -> Void {
		switch theme {
		case .Bright:
			textLabel?.textColor = UIColor.bright_MainTextColor()
			detailTextLabel?.textColor = UIColor.bright_SubTextColor()
		case .Dark:
			textLabel?.textColor = UIColor.dark_MainTextColor()
			detailTextLabel?.textColor = UIColor.dark_SubTextColor()
		}
	}

}
