//
//  UITableView+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UITableView: AppearanceAdaptable {

	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UITableView.appearance().backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			UITableView.appearance().backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}

extension UITableView: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Bright:
			backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}
