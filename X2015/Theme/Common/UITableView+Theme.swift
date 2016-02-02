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
		case .Default:
			UITableView.appearance().backgroundColor = UIColor.default_ViewControllerBackgroundColor()
		case .Night:
			UITableView.appearance().backgroundColor = UIColor.night_ViewControllerBackgroundColor()
		}
	}

}

extension UITableView: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Default:
			backgroundColor = UIColor.default_ViewControllerBackgroundColor()
		case .Night:
			backgroundColor = UIColor.night_ViewControllerBackgroundColor()
		}
	}

}
