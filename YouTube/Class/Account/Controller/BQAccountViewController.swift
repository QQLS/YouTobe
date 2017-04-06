//
//  BQAccountViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

private let headerCellReuseID = BQAccountHeaderCell.nameOfClass
private let menuCellReuseID = BQAccountMenuCell.nameOfClass
private let playListCellReuseID = BQAccountPlayListCell.nameOfClass

class BQAccountViewController: BQBaseCollectionViewController {
    
    var account = BQAccountModel(backgroundImage: nil, name: "Loading...", profilePic: nil, playLists: [])
    let menuImages = [Asset.History, Asset.My_Videos, Asset.Notifications, Asset.Watch_Later]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadNewData() {
        BQAccountModel.fetchAccountInfo(with: URLLink.account.link()) { (account: BQAccountModel?) in
            if let account = account {
                self.account = account
                self.collectionView?.reloadData()
            }
        }
    }
    override func loadMoreData() {
    }
}

// MARK: - UICollectionViewDataSource
extension BQAccountViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + menuImages.count + (account.playlists?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var returnCell = UICollectionViewCell()
        if case 0 = indexPath.item  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellReuseID, for: indexPath) as! BQAccountHeaderCell
            cell.account = account
            returnCell = cell
        } else if case 1...4 = indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellReuseID, for: indexPath) as! BQAccountMenuCell
            cell.setWith(image: menuImages[indexPath.item - 1].image, title: menuImages[indexPath.item - 1].rawValue, hiddenLine: 4 != indexPath.item)
            returnCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCellReuseID, for: indexPath) as! BQAccountPlayListCell
            cell.listItem = account.playlists?[indexPath.item - 5]
            returnCell = cell
        }
        return returnCell
    }
}

// MARK: - UICollectionViewDelegate
extension BQAccountViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BQAccountViewController {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if case 0 = indexPath.item  {
            return CGSize(width: collectionView.width, height: 120)
        } else if case 1...4 = indexPath.item {
            return CGSize(width: collectionView.width, height: 50)
        } else {
            return CGSize(width: collectionView.width, height: 70)
        }
    }
}
