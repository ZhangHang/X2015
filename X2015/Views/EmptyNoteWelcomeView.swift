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
		case .Default:
			backgroundColor = UIColor.default_ViewControllerBackgroundColor()
		case .Night:
			backgroundColor = UIColor.night_ViewControllerBackgroundColor()
		}
	}

}
