//
//  Int+Time.swift
//  YouTube
//
//  Created by xiupai on 2017/3/23.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import Foundation

extension Int {
    func toTimeString() -> String {
        return String(format: "%02ld", self)
    }
    
    var time: String? {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        let result = minutes.toTimeString() + ":" + seconds.toTimeString()
        if hours != 0 {
            return hours.toTimeString() + ":" + result
        }
        return result
    }
}
