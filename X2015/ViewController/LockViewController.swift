//
//  LockViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class LockViewController: UIViewController {}

extension LockViewController: SotyboardCreatable {

	static var storyboardName: String {
		return "Main"
	}

	static var viewControllerIdentifier: String {
		return "LockViewController"
	}

}
