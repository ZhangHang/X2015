//
//  EmptyNoteWelcomeView.swift
//  X2015
//
//  Created by Hang Zhang on 1/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class EmptyNoteWelcomeView: UIView {}

extension EmptyNoteWelcomeView: NibLoadable {}

extension EmptyNoteWelcomeView: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Bright:
			backgroundColor = UIColor.bright_ViewControllerBackgroundColor()
		case .Dark:
			backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
	}

}
