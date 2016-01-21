//
//  SotyboardCreatable.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

protocol SotyboardCreatable: class {

	static var storyboardName: String { get }
	static var viewControllerIdentifier: String { get }

}

extension SotyboardCreatable where Self: UIViewController {

	static func instanceFromStoryboard() -> Self? {
		return instanceFromStoryboardHelper()
	}

	private static func instanceFromStoryboardHelper<T>() -> T? {
		let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
		return storyboard.instantiateViewControllerWithIdentifier(viewControllerIdentifier) as? T
	}

}
