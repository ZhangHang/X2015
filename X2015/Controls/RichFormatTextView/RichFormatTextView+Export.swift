//
//  RichFormatTextView+Export.swift
//  X2015
//
//  Created by Hang Zhang on 2/19/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension RichFormatTextView {

	func exportToImage() -> UIImage {
		let orignalShowsVerticalScrollIndicator = showsVerticalScrollIndicator
		showsVerticalScrollIndicator = false
		editable = false
		let orignalContentOffset = self.contentOffset
		let orignalFrame = self.frame
		contentOffset = CGPointZero
		frame.origin = CGPointZero
		frame.size = contentSize

		UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.mainScreen().scale)
		drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
		let snapshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		contentOffset = orignalContentOffset
		frame = orignalFrame
		editable = true
		showsHorizontalScrollIndicator = orignalShowsVerticalScrollIndicator
		return snapshot
	}

}
