//
//  UITextField+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UITextField: AppearanceAdaptable {

	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			UITextField.appearance().keyboardAppearance = .Light
		case .Dark:
			UITextField.appearance().keyboardAppearance = .Dark
		}
	}

}
