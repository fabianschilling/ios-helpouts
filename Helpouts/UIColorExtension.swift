//
//  UIColorExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/3/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func colorFromRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    class func colorFromRGBA(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    class var helpoutsColor: UIColor {
        return UIColor.colorFromRGB(105, green: 154, blue: 45)
    }
}
