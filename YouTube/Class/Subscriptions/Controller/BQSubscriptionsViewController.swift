//
//  BQSubscriptionsViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

private let subscriptionTopCellReuseID = BQSubscriptionTopCell.nameOfClass

class BQSubscriptionsViewController: BQBaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollectionViewDataSource
extension BQSubscriptionsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if 0 == indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subscriptionTopCellReuseID, for: indexPath)
            return cell
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellReuseID, for: indexPath) as? BQVideoListCell {
                cell.videoModel = videoList[indexPath.item - 1]
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BQSubscriptionsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if 0 == indexPath.item {
            return CGSize(width: collectionView.width, height: 70)
        } else {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
}
