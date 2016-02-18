//
//  RichFormatTextView+AccessoryView.swift
//  X2015
//
//  Created by Hang Zhang on 2/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension RichFormatTextView {

	func setupInputAccessoryView() {
		guard let inputAccessoryView = RichFormatTextViewInputAccessoryView.instantiateFromNib() else {
			fatalError()
		}
		({
			$0.rightArrowButton.target = self
			$0.leftArrowButton.target = self
			$0.indentButton.target = self
			$0.headerButton.target = self
			$0.listButton.target = self
			$0.emphButton.target = self
			$0.linkButton.target = self
			$0.qouteButton.target = self

			$0.leftArrowButton.action = "handleLeftArrowButtonPressed"
			$0.rightArrowButton.action = "handleRightArrowButtonPressed"
			$0.indentButton.action = "handleIndentButtonPressed"
			$0.headerButton.action = "handleHeaderButtonPressed"
			$0.listButton.action = "handleListButtonPressed"
			$0.emphButton.action = "handleEmphButtonPressed"
			$0.linkButton.action = "handleLinkButtonPressed"
			$0.qouteButton.action = "handleQuoteButtonPressed"
		})(inputAccessoryView)

		self.inputAccessoryView = inputAccessoryView
	}

	// MARK: AccessoryView Methods
	@objc
	private func handleLeftArrowButtonPressed() {
		shortcutHandler?.moveCursorLeft()
	}

	@objc
	func handleRightArrowButtonPressed() {
		shortcutHandler?.moveCursorRight()
	}

	@objc
	private func handleHeaderButtonPressed() {
		shortcutHandler?.addHeaderSymbolIfNeeded()
	}

	@objc
	private func handleIndentButtonPressed() {
		shortcutHandler?.addIndentSymbol()
	}

	@objc
	private func handleQuoteButtonPressed() {
		shortcutHandler?.addQuoteSymbol()
	}

	@objc
	private func handleListButtonPressed() {
		shortcutHandler?.makeTextList()
	}

	@objc
	private func handleEmphButtonPressed() {
		shortcutHandler?.addEmphSymbol()
	}

	@objc
	private func handleLinkButtonPressed() {
		shortcutHandler?.addLinkSymbol()
	}
}
