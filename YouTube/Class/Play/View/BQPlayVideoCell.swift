
//
//  BQPlayVideoCell.swift
//  YouTube
//
//  Created by xiupai on 2017/4/5.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import Kingfisher

class BQPlayVideoCell: UITableViewCell {
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumArtImage: UIImageView!
    
    var video: BQSuggestedVideoModel? {
        didSet {
            guard let realVideo = video else { return }
            
            albumTitleLabel.text = realVideo.title
            albumNameLabel.text = realVideo.name
            albumArtImage.kf.setImage(with: realVideo.thumbnail_image_name?.url)
        }
    }
}
