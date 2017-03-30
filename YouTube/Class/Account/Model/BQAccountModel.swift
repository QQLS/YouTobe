//
//  BQAccountModel.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

final class BQPlayList: BQModelProtocol {
    
    var numberOfVideos: Int?
    var pic: String?
    var title: String?
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        numberOfVideos <- map["numberOfVideos"]
        pic <- map["pic"]
        title <- map["title"]
    }
}

final class BQAccountModel: BQModelProtocol {
    
    var backgroundImage: String?
    var name: String?
    var playlists: [BQPlayList]?
    var profilePic: String?
    
    init(backgroundImage: String?, name: String?, profilePic: String?, playLists: [BQPlayList]?) {
        self.backgroundImage = backgroundImage
        self.name = name
        self.profilePic = profilePic
        self.playlists = playLists
    }
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        backgroundImage <- map["backgroundImage"]
        name <- map["name"]
        playlists <- map["playlists"]
        profilePic <- map["profilePic"]
    }
    
    class func fetchAccountInfo(with url: URL, complete: ((BQAccountModel?) -> Void)?) {
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<BQAccountModel>) in
            if let complete = complete {
                complete(response.value)
            }
        }
    }
}
