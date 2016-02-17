//
//  MainSplitViewController+Delegate.swift
//  X2015
//
//  Created by Hang Zhang on 2/14/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension MainSplitViewController: UISplitViewControllerDelegate {

	func splitViewController(
		splitViewController: UISplitViewController,
		collapseSecondaryViewController secondaryViewController: UIViewController,
		ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
			guard let vc = secondaryViewController.childViewControllers.first as? NoteEditViewController else {
				fatalError()
			}
			switch vc.editingMode {
			case .Empty:
				return true
			default:
				return false
			}
	}

}
