//
//  BQSubscriptionTopCell.swift
//  YouTube
//
//  Created by xiupai on 2017/3/30.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import Alamofire

private let profileCellReuseID = BQProfileCell.nameOfClass

class BQSubscriptionTopCell: UICollectionViewCell {
    
    @IBOutlet weak var profileListCollection: UICollectionView!
    
    var profileImages: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileListCollection.delegate = self
        profileListCollection.dataSource = self
        
        self .loadProfileImageList()
    }
    
    private func loadProfileImageList() {
        Alamofire.request(URLLink.subscriptions.link()).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if let result = response.value as? [String] {
                self.profileImages = result
            }
            self.profileListCollection.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BQSubscriptionTopCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imagesCount = profileImages?.count {
            return imagesCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellReuseID, for: indexPath) as! BQProfileCell
        cell.profileImageURL = profileImages?[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BQSubscriptionTopCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
    }
}
