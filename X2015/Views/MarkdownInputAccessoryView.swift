//
//  MarkdownInputAccessoryView.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class MarkdownInputAccessoryView: UIToolbar {

	@IBOutlet var leftArrowButton: UIBarButtonItem!
	@IBOutlet var rightArrowButton: UIBarButtonItem!
	@IBOutlet var indentButton: UIBarButtonItem!
	@IBOutlet var headerButton: UIBarButtonItem!
	@IBOutlet var listButton: UIBarButtonItem!
	@IBOutlet var emphButton: UIBarButtonItem!
	@IBOutlet var linkButton: UIBarButtonItem!
	@IBOutlet var qouteButton: UIBarButtonItem!

}

extension MarkdownInputAccessoryView: NibLoadable {}

extension MarkdownInputAccessoryView: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Default:
			backgroundColor = UIColor.default_ViewControllerBackgroundColor()
			return
		case .Night:
			backgroundColor = UIColor.night_ViewControllerBackgroundColor()
			return
		}
	}

}
