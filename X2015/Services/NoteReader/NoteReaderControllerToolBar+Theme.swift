//
//  NoteReaderControllerToolBar+Theme.swift
//  X2015
//
//  Created by Hang Zhang on 2/22/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteReaderControllerToolBar: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Default:
			barStyle = .Default
		case .Night:
			barStyle = .Black
		}
	}

}