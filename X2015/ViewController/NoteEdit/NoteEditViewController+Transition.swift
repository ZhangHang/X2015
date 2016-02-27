//
//  NoteEditViewController+Transition.swift
//  X2015
//
//  Created by Hang Zhang on 2/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

let enableInteractiveTransition = false

extension NoteEditViewController {

	@IBAction func handleEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
		if !enableInteractiveTransition {
			if sender.state == .Began {
				performSegueWithIdentifier(NotePreviewViewController.SegueIdentifier.Present, sender: self)
			}
			return
		}
		switch sender.state {
		case .Began:
			navigationController?.delegate = self
			edgePanStartPoint = sender.locationInView(navigationController!.view)
			presentAnimator = HorizontalPresentAnimator()
			performSegueWithIdentifier(NotePreviewViewController.SegueIdentifier.Present, sender: self)
		case .Changed:
			guard
				let edgePanStartPoint = self.edgePanStartPoint,
				let presentAnimator = presentAnimator else {
					fatalError()
			}
			let progress = transitionProgress(
				edgePanStartPoint,
				currentPoint: sender.locationInView(navigationController!.view))
			presentAnimator.interactiveTransition.updateInteractiveTransition(progress)
		case .Ended, .Cancelled, .Failed:
			guard
				let edgePanStartPoint = self.edgePanStartPoint,
				let presentAnimator = presentAnimator else {
					fatalError()
			}
			if transitionProgress(
				edgePanStartPoint,
				currentPoint: sender.locationInView(navigationController!.view)) > 0.5 {
					presentAnimator.interactiveTransition.finishInteractiveTransition()
			} else {
				presentAnimator.interactiveTransition.cancelInteractiveTransition()
			}
			self.presentAnimator = nil
			navigationController?.delegate = nil
		default:
			return
		}
	}

	func transitionProgress(startPoint: CGPoint, currentPoint: CGPoint) -> CGFloat {
		let progress = (startPoint.x - currentPoint.x) / CGRectGetWidth(view.bounds)
		return progress
	}

}

extension NoteEditViewController: UINavigationControllerDelegate {

	func navigationController(navigationController: UINavigationController,
		animationControllerForOperation operation: UINavigationControllerOperation,
		fromViewController fromVC: UIViewController,
		toViewController toVC: UIViewController)
		-> UIViewControllerAnimatedTransitioning? {
			if operation == .Push {
				return presentAnimator
			}
			return nil
	}

	func navigationController(navigationController: UINavigationController,
		interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning)
		-> UIViewControllerInteractiveTransitioning? {
			return presentAnimator?.interactiveTransition
	}

}
