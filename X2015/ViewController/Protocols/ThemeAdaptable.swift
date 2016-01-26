//
//  ThemeAdaptable.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

enum Theme: String {
	case Bright, Dark
}

protocol AppearanceAdaptable: class {

	static func configureThemeAppearance(theme: Theme) -> Void

}

protocol ThemeAdaptable: class {

	func configureTheme(theme: Theme) -> Void

}
