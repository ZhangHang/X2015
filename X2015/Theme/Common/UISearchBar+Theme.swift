//
//  UISearchBar+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UISearchBar: AppearanceAdaptable {

	static func configureThemeAppearance(theme: Theme) {
		UISearchBar.appearance().tintColor = UIColor.whiteColor()
		switch theme {
		case .Defualt:
			UISearchBar.appearance().barTintColor = nil
			break
		case .Night:
			UISearchBar.appearance().barTintColor = UIColor.night_tableViewCellBackgroundColor()
			break
		}
	}

}

extension UISearchBar: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		tintColor = UIColor.whiteColor()
		switch theme {
		case .Defualt:
			barTintColor = nil
			break
		case .Night:
			barTintColor = UIColor.night_tableViewCellBackgroundColor()
			break
		}
	}

}
