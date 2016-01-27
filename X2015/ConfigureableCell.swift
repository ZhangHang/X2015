//
//  ConfigureableCell.swift
//  X2015
//
//  Created by Hang Zhang on 1/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

protocol ConfigureableCell: class {

    static var reuseIdentifier: String! { get }

}

extension ConfigureableCell where Self: UITableViewCell {

	static var reuseIdentifier: String! {
		return NSStringFromClass(Self).componentsSeparatedByString(".").last
	}

}
