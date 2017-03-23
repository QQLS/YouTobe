//
//  BQVideoItem.swift
//  YouTube
//
//  Created by xiupai on 2017/3/21.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class BQChannel: BQModelProtocol {
    
    var name: String?
    var profile_image_name: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        profile_image_name <- map["profile_image_name"]
    }
}

class BQVideoItem: BQModelProtocol {
    
    // MARK: - Properties
    var channel: BQChannel?
    var duration: String?
    var number_of_views: Int?
    var thumbnail_image_name: String = ""
    var title: String?
    
    // MARK: - BQModelProtocol
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        channel <- map["channel"]
        duration <- (map["duration"], TransformerTimestampToTime)
        number_of_views <- map["number_of_views"]
        thumbnail_image_name <- map["thumbnail_image_name"]
        title <- map["title"]
    }
    
    // MARK: - Method
    class func fetchVideoItemList(from url: URL, complete: (([BQVideoItem]?) -> (Void))?) {
        Alamofire.request(url, method: .get).responseArray { (response: DataResponse<[BQVideoItem]>) in
            guard let complete = complete else {
                return
            }
            
            complete(response.value)
        }
    }
}
