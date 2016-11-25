//
//  UIColor+IntegerValues.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

public func SAColor(red: Int, green: Int, blue: Int) -> UIColor {
    let r = CGFloat(CGFloat(red) / CGFloat(255.0))
    let g = CGFloat(CGFloat(green) / CGFloat(255.0))
    let b = CGFloat(CGFloat(blue) / CGFloat(255.0))
    return UIColor(red: r, green: g, blue: b, alpha: 1)
}
