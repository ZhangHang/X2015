//
//  UITextView+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

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
