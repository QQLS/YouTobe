//
//  BQSuggestedVideoModel.swift
//  YouTube
//
//  Created by xiupai on 2017/4/5.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import ObjectMapper

final class BQSuggestedVideoModel: BQModelProtocol {
    
    var title: String?
    var name: String?
    var thumbnail_image_name: String?
    
    func mapping(map: Map) {
        title <- map["title"]
        name <- map["name"]
        thumbnail_image_name <- map["thumbnail_image_name"]
    }
    
    init?(map: Map) {
    }
}
