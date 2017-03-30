//
//  BQMainViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

private let mainCellReuseID = UICollectionViewCell.nameOfClass

class BQMainViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate lazy var subControllers: [UIViewController] = {
        return [BQHomeViewController.nameOfClass, BQTrendingViewController.nameOfClass, BQSubscriptionsViewController.nameOfClass, BQAccountViewController.nameOfClass].map {
            guard let subContr = self.storyboard?.instantiateViewController(withIdentifier: $0) else {
                return UIViewController()
            }
            return subContr
        }
    } ()
    
    // MARK: - Views
    private lazy var collcetionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mainCellReuseID)
        return collectionView
    } ()
    
    private lazy var tabBar: BQTabBar = {
        let tabBar = BQTabBar(frame: .zero)
        return tabBar
    } ()
    
    private lazy var searchBar: BQSearchView = {
        let searchBar = BQSearchView(frame: kScreenBounds)
        return searchBar
    } ()
    
    private lazy var settingView: BQSettingView = {
        let settingView = BQSettingView(frame: kScreenBounds)
        return settingView
    } ()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.text = "Home"
        return titleLabel
    } ()
    
    // MARK: - Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p_setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(BQMainViewController.hiddenNavigationBar(with:)), name: NSNotification.Name(NavigationWillHiddenNotification), object: nil)
    }
    
    private func p_setupView() {
        // 如果 navigationBar 是透明的,那么下部的 view 会从(0, 0)开始,可以通过设置 isTranslucent 为 false 来解决
        // self.navigationController?.navigationBar.isTranslucent = false
        
        // TitleLabel
        navigationController?.navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        // TabBar
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kStatusAndNavigationHeight)
        }
        
        // CollectionView
        view.addSubview(collcetionView)
        collcetionView.backgroundColor = .blue
        collcetionView.snp.makeConstraints { (make) in
            make.left.bottom.centerX.equalToSuperview()
            make.top.equalTo(tabBar.snp.bottom)
        }
    }
    
    // MARK: - Action
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(searchBar)
            searchBar.show()
        }
    }
    
    @IBAction func moreAction(_ sender: UIBarButtonItem) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(settingView)
            settingView.show()
        }
    }
    
    func hiddenNavigationBar(with notification: Notification) {
        DispatchQueue.main.async { 
            if let hidden = notification.object as? Bool {
                self.navigationController?.setNavigationBarHidden(hidden, animated: true)
            }
            self.collcetionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BQMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellReuseID, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension BQMainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard subControllers.count > indexPath.item else {
            return
        }
        let subContr = subControllers[indexPath.item]
        if !subContr.isViewLoaded {
            addChildViewController(subContr)
            cell.contentView.addSubview(subContr.view)
            subContr.view.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            subContr.didMove(toParentViewController: self)
        } else {
            cell.contentView.addSubview(subContr.view)
            subContr.view.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BQMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size
    }
}
