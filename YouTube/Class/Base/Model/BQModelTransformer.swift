//
//  BQModelTransformer.swift
//  YouTube
//
//  Created by xiupai on 2017/3/20.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import ObjectMapper

/**
 *  字符串转换为 Int
 */
let TransformerStringToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    guard let value = value else {
        return 0
    }
    return Int(value)
}) { (value: Int?) -> String? in
    guard let value = value else {
        return nil
    }
    return String(value)
}

/**
 *  字符串转换为 Float
 */
let TransformerStringToFloat = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
    guard let value = value else {
        return 0
    }
    return Float(value)
}) { (value: Float?) -> String? in
    guard let value = value else {
        return nil
    }
    return String(value)
}

/**
 *  字符串转换为 CGFloat
 */
let TransformerStringToCGFloat = TransformOf<CGFloat, String>(fromJSON: { (value: String?) -> CGFloat? in
    guard let value = value else {
        return 0
    }
    return CGFloat(Int(value)!)
}) { (value: CGFloat?) -> String? in
    guard let value = value else {
        return nil
    }
    return String(describing: value)
}

/**
 *  时间戳转换为 String
 */
let TransformerTimestampToTime = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
    guard let value = value else {
        return ""
    }
    
    return value.time
}) { (value: String?) -> Int? in
    return nil
}
