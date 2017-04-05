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
    
    fileprivate var itemSize = CGSize.zero
    fileprivate var isCanScroll = false
    
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
    fileprivate lazy var collcetionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: kStatusAndNavigationHeight, width: kScreenWidth, height: kScreenHeight - kStatusAndNavigationHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mainCellReuseID)
        return collectionView
    } ()
    
    fileprivate lazy var tabBar: BQTabBar = {
        let tabBar = BQTabBar(frame: .zero)
        tabBar.delegate = self
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
        
        // CollectionView
        view.addSubview(collcetionView)
        // 如果添加约束的话,会导致 collectionView 在导航栏消失和隐藏的时候会闪动的问题
//        collcetionView.snp.makeConstraints { (make) in
//            make.left.bottom.centerX.equalToSuperview()
//            make.top.equalTo(tabBar.snp.bottom)
//        }
        
        // TabBar
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kStatusAndNavigationHeight)
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
            cell.addSubview(subContr.view)
            subContr.view.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            subContr.didMove(toParentViewController: self)
        } else {
            cell.addSubview(subContr.view)
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

// MARK: - UIScrollViewDelegate
extension BQMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isCanScroll {
            let index = Double(scrollView.contentOffset.x / scrollView.width) + 0.5
            let indexPath = IndexPath.init(item: Int(index), section: 0)
            tabBar.switchSelectItem(to: indexPath)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isCanScroll = true
    }
}

// MARK: - BQTabBarDelegate
extension BQMainViewController: BQTabBarDelegate {
    
    func didSelectItem(at indexPath: IndexPath) {
        isCanScroll = false
        self.collcetionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
