//
//  UIImage+Extension.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//
// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    typealias Image = UIImage
#elseif os(OSX)
    import AppKit.NSImage
    typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
    case Account = "account"
    case AccountDark = "accountDark"
    case Avatar = "avatar"
    case Cancel = "cancel"
    case EmptyTumbnail = "emptyTumbnail"
    case Help = "help"
    case History = "History"
    case Home = "home"
    case HomeDark = "homeDark"
    case Live = "live"
    case Logo = "logo"
    case Minimize = "minimize"
    case Music = "music"
    case My_Videos = "My Videos"
    case Nav_more_icon = "nav_more_icon"
    case News = "news"
    case Notifications = "Notifications"
    case Search_icon = "search_icon"
    case SendFeedback = "sendFeedback"
    case Settings = "settings"
    case Subscriptions = "subscriptions"
    case SubscriptionsDark = "subscriptionsDark"
    case SwithAccount = "swithAccount"
    case TermsPrivacyPolicy = "termsPrivacyPolicy"
    case ThumbDown = "thumbDown"
    case ThumbUp = "thumbUp"
    case Trending = "trending"
    case TrendingDark = "trendingDark"
    case Watch_Later = "Watch Later"
    
    var image: Image {
        let bundle = Bundle.init(for: BundleToken.self)
        #if os(iOS) || os(tvOS) || os(watchOS)
            let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.imageForResource(rawValue)
        #endif
        guard let result = image else { fatalError("Unable to load image \(rawValue).") }
        return result
    }
}
// swiftlint:enable type_body_length

extension Image {
    convenience init!(asset: Asset) {
        #if os(iOS) || os(tvOS) || os(watchOS)
            let bundle = Bundle.init(for: BundleToken.self)
            self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: asset.rawValue)
        #endif
    }
}

private final class BundleToken {}
