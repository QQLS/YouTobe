//
//  BQProfileCell.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

class BQProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var profileImageURL: String? {
        didSet {
            guard let imageURL = profileImageURL else {
                return
            }
            profileImage.kf.setImage(with: imageURL.url)
        }
    }
}
