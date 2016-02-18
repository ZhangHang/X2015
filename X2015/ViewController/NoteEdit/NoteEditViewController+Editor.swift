//
//  NoteEditViewController+Editor.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	func configureEditor() {
		textView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
		textView.didChange = { [unowned self] text in
			self.updateActionButtonIfNeeded()
			self.updateTitleIfNeeded()
			self.noteManager!.updateNote(text)
		}
		textView.didEndEditing = { [unowned self] in
			self.navigationController?.setNavigationBarHidden(false, animated: true)
			self.setNeedsStatusBarAppearanceUpdate()
		}
	}

}
