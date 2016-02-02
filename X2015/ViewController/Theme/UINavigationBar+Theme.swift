//
//  UINavigationBar+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/2/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UINavigationBar: AppearanceAdaptable {
	static func configureThemeAppearance(theme: Theme) {
		appearance().tintColor = UIColor.whiteColor()
	}
}

extension UINavigationBar: ThemeAdaptable {
	func configureTheme(theme: Theme) {
		tintColor = UIColor.whiteColor()
	}
}
