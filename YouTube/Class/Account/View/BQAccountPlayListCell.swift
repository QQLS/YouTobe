//
//  BQAccountPlayListCell.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

class BQAccountPlayListCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var listItem: BQPlayList? {
        didSet {
            coverImage.kf.setImage(with: listItem?.pic?.url)
            titleLabel.text = listItem?.title
            numberLabel.text = "\(listItem?.numberOfVideos ?? 0)"
        }
    }
}
