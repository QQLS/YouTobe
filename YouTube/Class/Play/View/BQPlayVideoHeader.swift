//
//  BQPlayVideoHeader.swift
//  YouTube
//
//  Created by xiupai on 2017/4/5.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import Kingfisher

class BQPlayVideoHeader: UIView {
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var delikesLabel: UILabel!
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubscribers: UILabel!
    
    var video: BQVideoModel? {
        didSet {
            guard let realVideo = video else { return }
            
            albumTitleLabel.text = realVideo.title
            viewersLabel.text = "\(realVideo.viewCount ?? 0) views"
            likesLabel.text = "\(realVideo.likes ?? 0)"
            delikesLabel.text = "\(realVideo.disLikes ?? 0)"
            channelImage.kf.setImage(with: realVideo.channelPic?.url)
            channelTitleLabel.text = realVideo.channelTitle
            channelSubscribers.text = "\(realVideo.channelSubscribers ?? 0) subscribers"
        }
    }
}
