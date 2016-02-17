//
//  NoteEditViewController+Shortcut.swift
//  X2015
//
//  Created by Hang Zhang on 2/13/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	/**
	Focus on editor if there is a note
	*/
	func startEditingIfNeeded() {
		switch editingMode {
		case .Empty:
			return
		default:
			textView.becomeFirstResponder()
		}
	}

}
