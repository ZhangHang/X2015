//
//  RichFormatTextView+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

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

extension RichFormatTextView: ThemeAdaptable {

	func configureTheme(theme: Theme) -> Void {
		guard let accessorView = inputAccessoryView as? RichFormatTextViewInputAccessoryView else {
			fatalError()
		}
		accessorView.configureTheme(theme)

		richFormatTextStorage.configureTheme(theme)
		refreshTextView_WORKAROUND()
		switch theme {
		case .Default:
			backgroundColor = UIColor.default_ViewControllerBackgroundColor()
			keyboardAppearance = .Light
		case .Night:
			backgroundColor = UIColor.night_ViewControllerBackgroundColor()
			keyboardAppearance = .Dark
		}
		reloadInputViews()
	}

}
