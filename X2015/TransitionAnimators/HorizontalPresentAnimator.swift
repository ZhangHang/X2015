//
//  HorizontalPresentAnimator.swift
//  X2015
//
//  Created by Hang Zhang on 2/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class HorizontalPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

	var interactiveTransition = UIPercentDrivenInteractiveTransition()

	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.75
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView()!
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

		containerView.addSubview(toViewController.view)

		let containerWidth = CGRectGetWidth(containerView.bounds)
		fromViewController.view.frame.origin.x = 0
		toViewController.view.frame.origin.x = containerWidth

		UIView.animateWithDuration(transitionDuration(transitionContext),
			delay: 0,
			options: .CurveLinear,
			animations: { () -> Void in
				fromViewController.view.frame.origin.x = -containerWidth
				toViewController.view.frame.origin.x = 0
			}) { (finish) -> Void in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
		}
	}

}
