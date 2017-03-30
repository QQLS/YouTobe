//
//  BQAccountMenuCell.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

class BQAccountMenuCell: UICollectionViewCell {
    
    @IBOutlet private weak var menuImage: UIImageView!
    @IBOutlet private weak var menuTitle: UILabel!
    @IBOutlet weak var seperatorLine: UIView!
    
    func setWith(image: UIImage, title: String, hiddenLine: Bool) {
        menuImage.image = image
        menuTitle.text = title
        seperatorLine.isHidden = hiddenLine
    }
}
