//
//  BQVideoModel.swift
//  YouTube
//
//  Created by xiupai on 2017/4/5.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

final class BQVideoModel: BQModelProtocol {
    
    var channelPic: String?
    var channelSubscribers: Int?
    var channelTitle: String?
    var disLikes: Int?
    var likes: Int?
    var suggestedVideos: [BQSuggestedVideoModel]?
    var title: String?
    var videoLink: String?
    var viewCount: Int?
    
    func mapping(map: Map) {
        channelPic <- map["channelPic"]
        channelSubscribers <- map["channelSubscribers"]
        channelTitle <- map["channelTitle"]
        disLikes <- map["disLikes"]
        likes <- map["likes"]
        suggestedVideos <- map["suggestedVideos"]
        title <- map["title"]
        videoLink <- map["videoLink"]
        viewCount <- map["viewCount"]
    }
    
    init?(map: Map) {
    }
    
    class func fetchVideoList(with url: URL, complete: ((BQVideoModel?) -> Void)?) {
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<BQVideoModel>) in
            if let complete = complete {
                complete(response.value)
            }
        }
    }
}
