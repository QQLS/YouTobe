
//
//  BQBaseCollectionViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/21.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

let videoCellReuseID = BQVideoListCell.nameOfClass

class BQBaseCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var videoList = [BQVideoItem]()
    let refreshControl = UIRefreshControl()
    var lastContentOffset: CGFloat = 0
    
    var loadNewDataURL = URLLink.home.link()
    var loadMoreDataURL = URLLink.trending.link()
    
    // MARK: - Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        p_setupView()
        loadNewData()
    }
    
    func p_setupView() {
        self.clearsSelectionOnViewWillAppear = true
        
        // 设置并添加刷新控件
        refreshControl.addTarget(self, action: #selector(loadNewData), for: .valueChanged)
        refreshControl.tintColor = kSchemeColor
        collectionView?.addSubview(refreshControl)
        collectionView?.register(UINib.init(nibName: videoCellReuseID, bundle: nil), forCellWithReuseIdentifier: videoCellReuseID)
    }
    
    // MARK: - Action
    func loadNewData() {
        videoList.removeAll()
        fetchVideoList(with: loadNewDataURL)
    }
    
    func loadMoreData() {
        fetchVideoList(with: loadMoreDataURL)
    }
    
    func fetchVideoList(with url: URL) {
        BQVideoItem.fetchVideoItemList(from: url) { (itemList: [BQVideoItem]?) in
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellReuseID, for: indexPath) as! BQVideoListCell
        cell.videoModel = videoList[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BQBaseCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(PlayChangeNotification), object: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BQBaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.width * (9 / 16.0) + 67.0
        return CGSize(width: collectionView.width, height: itemHeight)
    }
}

// MARK: - UIScrollViewDelegate
extension BQBaseCollectionViewController {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.height > scrollView.contentSize.height - 100 {
            loadMoreData()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.height {
            lastContentOffset = scrollView.contentSize.height - scrollView.height
            return
        }
        
        if let hidden = navigationController?.navigationBar.isHidden {
            if scrollView.contentOffset.y > 100 {
                if lastContentOffset > scrollView.contentOffset.y {
                    if hidden {
                        NotificationCenter.default.post(name: NSNotification.Name(NavigationWillHiddenNotification), object: false)
                    }
                } else {
                    if !hidden {
                        NotificationCenter.default.post(name: NSNotification.Name(NavigationWillHiddenNotification), object: true)
                    }
                }
            } else {
                if hidden {
                    NotificationCenter.default.post(name: NSNotification.Name(NavigationWillHiddenNotification), object: false)
                }
            }
        }
    }
}
