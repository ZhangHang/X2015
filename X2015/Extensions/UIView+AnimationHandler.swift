//
//  UIView+AnimationHandler.swift
//  X2015
//
//  Created by Hang Zhang on 1/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension UIView {

	public func pauseAnimation() {
		let pauseTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
		layer.speed = 0
		layer.timeOffset = pauseTime
	}

	public func resumeAnimation() {
		let pauseTime = layer.timeOffset
		layer.speed = 1
		layer.timeOffset = 0
		layer.beginTime = 0
		let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
		layer.beginTime = timeSincePause
	}

}
