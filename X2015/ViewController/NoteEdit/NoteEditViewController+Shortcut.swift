//
//  NoteEditViewController+Shortcut.swift
//  X2015
//
//  Created by Hang Zhang on 2/13/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	func startEditingIfNeeded() {
		switch noteActionMode {
		case .Empty:
			return
		default:
			textView.becomeFirstResponder()
		}
	}

}
