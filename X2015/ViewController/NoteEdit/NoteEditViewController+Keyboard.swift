//
//  NoteEditViewController+Keyboard.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	func registerForKeyboardEvent() {
		NSNotificationCenter.defaultCenter().addObserverForName(
			UIKeyboardWillChangeFrameNotification,
			object: nil,
			queue: NSOperationQueue.mainQueue()) { [unowned self] (notification) -> Void in
				let initialRect = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue
				let _ = self.view.frame.size.height - self.view.convertRect(initialRect!, fromView: nil).origin.y
				let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
				let newHeight = self.view.frame.size.height - self.view.convertRect(keyboardRect!, fromView: nil).origin.y

				self.textView.contentInset = { [unowned self] in
					var insect = self.textView.contentInset
					insect.bottom = newHeight
					return insect
				}()

				let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
				let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue

				UIView.animateWithDuration(
					duration!,
					delay: 0,
					options: [UIViewAnimationOptions(rawValue: curve!), .BeginFromCurrentState],
					animations: { () -> Void in
						self.textView.layoutIfNeeded()
					}, completion: nil)
		}

		// Partial fixes to a long standing bug, to keep the caret inside the `UITextView` always visible
		NSNotificationCenter.defaultCenter().addObserverForName(
			UITextViewTextDidChangeNotification,
			object: textView,
			queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
				if self.textView.richFormatText.hasSuffix("\n") {
					CATransaction.setCompletionBlock({ () -> Void in
						self.scrollToCaret(self.textView, animated: false)
					})
				} else {
					self.scrollToCaret(self.textView, animated: false)
				}
		}
	}

	private func scrollToCaret(textView: UITextView, animated: Bool) {
		var rect = textView.caretRectForPosition(textView.selectedTextRange!.end)
		rect.size.height = rect.size.height + textView.textContainerInset.bottom
		textView.scrollRectToVisible(rect, animated: animated)
	}

}
