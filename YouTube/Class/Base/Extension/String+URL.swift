//
//  String+URL.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import Foundation

extension String {
    var url: URL? {
        return URL.init(string: self)
    }
}
