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

	static func night_BlackColor() -> UIColor {
		return UIColor(red: 54/255.0, green: 58/255.0, blue: 62/255.0, alpha: 1)
	}

	static func night_lightBlackColor() -> UIColor {
		return UIColor(red: 74/255.0, green: 78/255.0, blue: 81/255.0, alpha: 1)
	}

}

extension UIColor {

	static func default_ViewControllerBackgroundColor() -> UIColor {
		return UIColor.whiteColor()
	}

	static func night_ViewControllerBackgroundColor() -> UIColor {
		return night_BlackColor()
	}

}

extension UIColor {

	static func default_tableViewBackgroundColor() -> UIColor {
		return UIColor.groupTableViewBackgroundColor()
	}

	static func night_tableViewBackgroundColor() -> UIColor {
		return night_ViewControllerBackgroundColor()
	}

	static func default_tableViewCellBackgroundColor() -> UIColor {
		return UIColor.whiteColor()
	}

	static func night_tableViewCellBackgroundColor() -> UIColor {
		return night_lightBlackColor()
	}

}

extension UIColor {

	static func default_MainTextColor() -> UIColor {
		return UIColor.blackColor()
	}

	static func night_MainTextColor() -> UIColor {
		return UIColor.whiteColor()
	}

	static func default_SubTextColor() -> UIColor {
		return UIColor.darkTextColor()
	}

	static func night_SubTextColor() -> UIColor {
		return UIColor.lightTextColor()
	}

}
