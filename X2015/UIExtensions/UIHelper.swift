//
//  UIHelper.swift
//  X2015
//
//  Created by Hang Zhang on 1/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class UIHelper: NSObject {

    // NavigationBar
    static func setupNavigationBarStyle(foregroundColor:UIColor, backgroundColor: UIColor) {
        UINavigationBar.appearance().barTintColor = foregroundColor
        UINavigationBar.appearance().tintColor = backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: backgroundColor]
    }
    
    static func setupNavigationBarStyle(foregroundColor:UIColor, backgroundColor: UIColor, barStyle: UIBarStyle) {
        self.setupNavigationBarStyle(foregroundColor, backgroundColor: backgroundColor)
        UINavigationBar.appearance().barStyle = barStyle
    }
    
}
