//
//  BQVideoListCell.swift
//  YouTube
//
//  Created by xiupai on 2017/3/23.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import Kingfisher

class BQVideoListCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var videoModel: BQVideoItem? {
        didSet {
            guard let realValue = videoModel else {
                return
            }
            videoImage.kf.setImage(with: URL(string: realValue.thumbnail_image_name))
            channelImage.kf.setImage(with: URL(string: (realValue.channel?.profile_image_name)!))
            titleLabel.text = realValue.title
            descriptionLabel.text = (realValue.channel?.name)! + String(describing: realValue.number_of_views)
            durationLabel.text = " " + realValue.duration! + " "
        }
    }
}
