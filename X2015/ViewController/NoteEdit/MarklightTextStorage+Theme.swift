//
//  MarklightTextStorage+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import Marklight

extension MarklightTextStorage: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Default:
			textColor = UIColor.blackColor()
			syntaxColor = UIColor.lightGrayColor()
			codeColor = UIColor.darkGrayColor()
			quoteColor = UIColor.darkGrayColor()
		case .Night:
			textColor = UIColor.whiteColor()
			syntaxColor = UIColor.lightGrayColor()
			codeColor = UIColor.darkGrayColor()
			quoteColor = UIColor.darkGrayColor()
		}
	}

}
