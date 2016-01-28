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
		case .Defualt:
			UITextField.appearance().keyboardAppearance = .Light
		case .Night:
			UITextField.appearance().keyboardAppearance = .Dark
		}
	}

}
