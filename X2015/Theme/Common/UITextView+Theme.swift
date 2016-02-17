//
//  UITextView+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UITextView: ThemeAdaptable {

	func configureTheme(theme: Theme) -> Void {
		backgroundColor = UIColor.clearColor()
		switch theme {
		case .Default:
			keyboardAppearance = .Light
		case .Night:
			keyboardAppearance = .Dark
		}
		reloadInputViews()
	}

}
