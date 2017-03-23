//
//  CALayer+UIColor.swift
//  YouTube
//
//  Created by xiupai on 2017/3/23.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import QuartzCore

extension CALayer {
    
    var borderColorFromUIColor: UIColor? {
        get {
            guard let borderC = borderColor else {
                return nil
            }
            return UIColor(cgColor: borderC)
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}
