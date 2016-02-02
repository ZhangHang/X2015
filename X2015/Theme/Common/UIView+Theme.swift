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
		case .Default:
			backgroundColor = UIColor.default_ViewControllerBackgroundColor()
		case .Night:
			backgroundColor = UIColor.night_ViewControllerBackgroundColor()
		}
	}

}
