//
//  NoteReaderControllerToolBar+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/20/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteReaderControllerToolBar: ThemeAdaptable {

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
