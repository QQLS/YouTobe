//
//  BQGlobal.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

// delegate 代理
let TSAppDelegate = UIApplication.shared.delegate as! AppDelegate

// 沙盒文档路径
let kSandDocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!

// 常量值
let kStatusBarHeight: CGFloat = 20
let kNavigationBarHeight: CGFloat = 44
let kStatusAndNavigationHeight: CGFloat =  kStatusBarHeight + kNavigationBarHeight
let kScreenBounds: CGRect = UIScreen.main.bounds
let kScreenWidth: CGFloat = kScreenBounds.size.width
let kScreenHeight: CGFloat = kScreenBounds.size.height
let kSchemeColor: UIColor = .rgb(r: 228, g: 34, b: 24)
let PlayChangeNotification = "PlayChangeNotification"
let NavigationWillHiddenNotification = "NavigationWillHiddenNotification"

enum URLLink: NSString {
    case home = "http://mexonis.com/home.json"
    case trending = "http://mexonis.com/more.json"
    case subscriptions = "http://mexonis.com/subscriptions.json"
    case account = "http://mexonis.com/profile.json"
    case video = "http://mexonis.com/video.json"
    
    func link() -> URL {
        return URL.init(string: self.rawValue as String)!
    }
    
    static func requestSuggestions(for text: String) -> URL {
        let netText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet())!
        let url = URL.init(string: "https://api.bing.com/osjson.aspx?query=\(netText)")!
        return url
    }
}

/**
 *  秒数转为 00:00:00 格式
 */
func hoursMinutesSeconds(from seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let second = (seconds % 3600) % 60
    let hoursString: String = {
        let hs = String(hours)
        return hs
    }()
    
    let minutesString: String = {
        var ms = ""
        if  (minutes <= 9 && minutes >= 0) {
            ms = "0\(minutes)"
        } else {
            ms = String(minutes)
        }
        return ms
    }()
    
    let secondsString: String = {
        var ss = ""
        if  (second <= 9 && second >= 0) {
            ss = "0\(second)"
        } else {
            ss = String(second)
        }
        return ss
    }()
    
    var label = ""
    if hours == 0 {
        label =  minutesString + ":" + secondsString
    } else {
        label = hoursString + ":" + minutesString + ":" + secondsString
    }
    return label
}

extension NSObject {
    
    /**
     获取对象对于的属性值，无对于的属性则返回NIL
     
     - parameter property: 要获取值的属性
     
     - returns: 属性的值
     */
    func getValueOfProperty(property:String) -> Any? {
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)) {
            return self.value(forKey: property)
        } else {
            return nil
        }
    }
    
    /**
     设置对象属性的值
     
     - parameter property: 属性
     - parameter value:    值
     
     - returns: 是否设置成功
     */
    func setValueOfProperty(property:String, value:AnyObject) -> Bool {
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)) {
            self.setValue(value, forKey: property)
            return true
        } else {
            return false
        }
    }
    /**
     获取对象的所有属性名称
     
     - returns: 属性名称数组
     */
    func getAllPropertys() -> [String] {
        
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        
        for i in 0..<countInt {
            let temp = buff?[i]
            let tempPro = property_getName(temp)
            let proper = String.init(utf8String: tempPro!)
            result.append(proper!)
        }
        return result
    }
}
