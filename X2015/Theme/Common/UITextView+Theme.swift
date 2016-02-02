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
		case .Default:
			UITextView.appearance().textColor = UIColor.default_MainTextColor()
			UITextView.appearance().backgroundColor = UIColor.clearColor()
		case .Night:
			UITextView.appearance().backgroundColor = UIColor.night_MainTextColor()
			UITextView.appearance().backgroundColor = UIColor.clearColor()
		}
	}

}

extension UITextView: ThemeAdaptable {

	func configureTheme(theme: Theme) -> Void {
		backgroundColor = UIColor.clearColor()
		switch theme {
		case .Default:
			keyboardAppearance = .Light
			textColor = UIColor.default_MainTextColor()
		case .Night:
			keyboardAppearance = .Dark
			textColor = UIColor.night_MainTextColor()
		}
		reloadInputViews()
	}

}
