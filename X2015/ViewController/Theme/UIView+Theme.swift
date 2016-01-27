//
//  UIView+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension ThemeAdaptable where Self: UIView {

	func configureTheme(theme: Theme) -> Void {
		switch theme {
		case .Bright:
			backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}
