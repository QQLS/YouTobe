//
//  BQTabBar.swift
//  YouTube
//
//  Created by xiupai on 2017/3/16.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import SnapKit

private let reuseIdentifier = BQTabBarItem.nameOfClass

protocol BQTabBarDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
}

class BQTabBar: UIView {
    
    let sideLineHeight = 5.0
    let itemNormal = [Asset.Home, Asset.Trending, Asset.Subscriptions, Asset.Account]
    let itemSelected = [Asset.HomeDark, Asset.TrendingDark, Asset.SubscriptionsDark, Asset.AccountDark]
    var oldSelectedIndexPath = IndexPath.init(item: 0, section: 0)
    var newSelectIndexPath = IndexPath.init(item: 0, section: 0)
    weak var delegate: BQTabBarDelegate?
    
    private lazy var collectionView: UICollectionView = { // 盛放 TabBarItem
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(BQTabBarItem.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    } ()
    
    private lazy var sideLine: UIView = { // 滚动的边线
        let sideLine = UIView()
        sideLine.backgroundColor = UIColor.rgb(r: 245, g: 245, b: 245)
        return sideLine
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        p_setupView()
    }
    
    private func p_setupView() {
        backgroundColor = kSchemeColor
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(sideLine)
        sideLine.snp.makeConstraints { (make) in
            make.height.equalTo(sideLineHeight)
            make.width.equalToSuperview().multipliedBy(1 / Float(itemNormal.count))
            make.left.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
        }
        
        let firstIndexPath = IndexPath.init(item: 0, section: 0)
        collectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        animateSideLine(to: firstIndexPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    func switchSelectItem(to indexPath: IndexPath) {
        if indexPath == oldSelectedIndexPath {
            return
        }
        oldSelectedIndexPath = newSelectIndexPath
        newSelectIndexPath = indexPath
        deselectItem(at: oldSelectedIndexPath)
        selectItem(at: newSelectIndexPath)
    }
    
    fileprivate func deselectItem(at indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let cell = collectionView.cellForItem(at: indexPath) as? BQTabBarItem {
            cell.itemImage.image = itemNormal[indexPath.item].image
        }
    }
    
    fileprivate func selectItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        if let cell = collectionView.cellForItem(at: indexPath) as? BQTabBarItem {
            cell.itemImage.image = itemSelected[indexPath.item].image
            animateSideLine(to: indexPath)
        }
    }
    
    fileprivate func animateSideLine(to indexPath: IndexPath) {
        sideLine.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(Float(indexPath.item) / Float(itemNormal.count) * Float(kScreenWidth))
        }
        UIView.animate(withDuration: 0.1) {
            self.sideLine.superview?.layoutIfNeeded()
        }
    }
}

extension BQTabBar: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemNormal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BQTabBarItem
        cell.itemImage.image = ((cell.isSelected ? itemSelected : itemNormal)[indexPath.item] as Asset).image
        return cell
    }
}

extension BQTabBar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        oldSelectedIndexPath = indexPath
        newSelectIndexPath = indexPath
        
        selectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath)
    }
}

extension BQTabBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth / 4, height: self.height)
    }
}

class BQTabBarItem: UICollectionViewCell {
    let itemImage = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(itemImage)
        itemImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
