//
//  BQAccountHeaderCell.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import Kingfisher

class BQAccountHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var account: BQAccountModel? {
        didSet {
            bgImage.kf.setImage(with: account?.backgroundImage?.url)
            avatarImage.kf.setImage(with: account?.profilePic?.url)
            nameLabel.text = account?.name
        }
    }
}
