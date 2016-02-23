//
//  RichFormatTextViewInputAccessoryView.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class RichFormatTextViewInputAccessoryView: UIToolbar {

	@IBOutlet var leftArrowButton: UIBarButtonItem!
	@IBOutlet var rightArrowButton: UIBarButtonItem!
	@IBOutlet var indentButton: UIBarButtonItem!
	@IBOutlet var headerButton: UIBarButtonItem!
	@IBOutlet var listButton: UIBarButtonItem!
	@IBOutlet var emphButton: UIBarButtonItem!
	@IBOutlet var linkButton: UIBarButtonItem!
	@IBOutlet var qouteButton: UIBarButtonItem!

}

extension RichFormatTextViewInputAccessoryView: NibLoadable {}

extension RichFormatTextViewInputAccessoryView: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Default:
			tintColor = UIColor.x2015_BlueColor()
			barStyle = .Default
		case .Night:
			tintColor = UIColor.whiteColor()
			barStyle = .Black
		}
	}

}
