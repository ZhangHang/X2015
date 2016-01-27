//
//  UITableViewCell+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

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
