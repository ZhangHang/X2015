//
//  UILabel+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UILabel: AppearanceAdaptable {

	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Defualt:
			UILabel.appearance().backgroundColor = UIColor.clearColor()
			UILabel.appearance().textColor = UIColor.defualt_MainTextColor()
		case .Night:
			UILabel.appearance().backgroundColor = UIColor.clearColor()
			UILabel.appearance().textColor = UIColor.night_MainTextColor()
		}
	}

}
