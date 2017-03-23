//
//  UIColor+Extension.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.init(red: (r) / 255, green: (g) / 255, blue: (b) / 255, alpha: (1))
    }
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return self.init(red: (r) / 255, green: (g) / 255, blue: (b) / 255, alpha: (a))
    }
    
    class var random: UIColor {
        return rgb(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
