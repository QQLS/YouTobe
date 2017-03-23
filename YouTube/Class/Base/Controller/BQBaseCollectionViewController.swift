
//
//  BQBaseCollectionViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/21.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

private let reuseIdentifier = BQVideoListCell.nameOfClass

class BQBaseCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var videoList = [BQVideoItem]()
    let refreshControl = UIRefreshControl()
    
    // MARK: - Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        p_setupView()
        fetchVideoList()
    }
    
    func p_setupView() {
        self.clearsSelectionOnViewWillAppear = true
        
        // 设置并添加刷新控件
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.rgb(r: 228, g: 34, b: 24)
        collectionView?.addSubview(refreshControl)
    }
    
    // MARK: - Action
    func refresh() {
        videoList.removeAll()
        fetchVideoList()
    }
    
    func fetchVideoList() {
        BQVideoItem.fetchVideoItemList(from: URLLink.home.link()) { (itemList: [BQVideoItem]?) in
            guard let itemList = itemList else {
                return
            }
            self.videoList += itemList
            DispatchQueue.main.async(execute: { 
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            })
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BQBaseCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BQVideoListCell
        cell.videoModel = videoList[indexPath.item]
        return cell
    }
}

extension BQBaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.cellForItem(at: indexPath)
//        [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]
//    }
}
