//
//  UITableViewCell+Reusable.swift
//  X2015
//
//  Created by Hang Zhang on 1/28/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

protocol ReusableCell: class {

	static var reusableIdentifier: String! { get }

}

extension ReusableCell where Self: UITableViewCell {

	static var reusableIdentifier: String! {
		return NSStringFromClass(Self).componentsSeparatedByString(".").last
	}

}

extension UITableView {

	func dequeueReusableCell<T: ReusableCell>(indexPath: NSIndexPath) -> T? {
		return dequeueReusableCellWithIdentifier(T.reusableIdentifier, forIndexPath: indexPath) as? T
	}

}
