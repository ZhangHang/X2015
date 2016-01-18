//
//  NibLoadable.swift
//  X2015
//
//  Created by Hang Zhang on 1/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

protocol NibLoadable {

    static var nibName: String! { get }

}

extension NibLoadable where Self: UIView {

    static var nibName: String! {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }

    static  func instantiateFromNib() -> Self? {
        return instantiateFromNibHelper()
    }

    private static func instantiateFromNibHelper<T>() -> T? {
        let topLevelObjects = NSBundle.mainBundle().loadNibNamed(self.nibName, owner: nil, options: nil)

        for topLevelObject in topLevelObjects {
            if let object = topLevelObject as? T {
                return object
            }
        }
        return nil
    }

}
