//
//  ConfigureableCell.swift
//  X2015
//
//  Created by Hang Zhang on 1/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

protocol ConfigureableCell: class {
    
    static var reuseIdentifier: String! { get }
    
}