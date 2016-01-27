//
//  UIWindow+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

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