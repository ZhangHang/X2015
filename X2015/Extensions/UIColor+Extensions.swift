//
//  UIColor+Extensions.swift
//  X2015
//
//  Created by Hang Zhang on 1/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UIColor {

    static func x2015_BlueColor() -> UIColor {
		return UIColor(red: 60/255.0, green: 123/255.0, blue: 218/255.0, alpha: 1)
    }

}

extension UIColor {

	static func dark_BlackColor() -> UIColor {
		return UIColor(red: 54/255.0, green: 58/255.0, blue: 62/255.0, alpha: 1)
	}

	static func dark_lightBlackColor() -> UIColor {
			return UIColor(red: 74/255.0, green: 78/255.0, blue: 81/255.0, alpha: 1)
	}

}

extension UIColor {

	static func bright_ViewControllerBackgroundColor() -> UIColor {
		return UIColor.whiteColor()
	}

	static func dark_ViewControllerBackgroundColor() -> UIColor {
		return dark_BlackColor()
	}

}

extension UIColor {

	static func bright_tableViewBackgroundColor() -> UIColor {
		return UIColor.groupTableViewBackgroundColor()
	}

	static func dark_tableViewBackgroundColor() -> UIColor {
		return dark_ViewControllerBackgroundColor()
	}

	static func bright_tableViewCellBackgroundColor() -> UIColor {
		return UIColor.whiteColor()
	}

	static func dark_tableViewCellBackgroundColor() -> UIColor {
		return dark_lightBlackColor()
	}

}

extension UIColor {

	static func bright_MainTextColor() -> UIColor {
		return UIColor.blackColor()
	}

	static func dark_MainTextColor() -> UIColor {
		return UIColor.whiteColor()
	}

	static func bright_SubTextColor() -> UIColor {
		return UIColor.darkTextColor()
	}

	static func dark_SubTextColor() -> UIColor {
		return UIColor.lightTextColor()
	}

}
