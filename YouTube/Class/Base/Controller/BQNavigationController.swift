//
//  BQNavigationController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

class BQNavigationController: UINavigationController, BQPlayViewControllerDelegate {
    
    // 上下两种写法是等价的
    /*
     let statusBar = { () -> UIView in
         let statusView = UIView.init(frame: UIApplication.shared.statusBarFrame)
         statusView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
         return statusView
     } ()
     */
    let statusBar: UIView = {
        let statusView = UIView.init(frame: UIApplication.shared.statusBarFrame)
        statusView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        return statusView
    } ()
    
    // 几个需要切换的点
    let hiddenOrigin: CGPoint = {
        let x = -UIScreen.main.bounds.width
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        return CGPoint.init(x: x, y: y)
    } ()
    let minimizeOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width / 2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        return CGPoint.init(x: x, y: y)
    } ()
    let fullScreenOrigin: CGPoint = CGPoint.zero
    
    // 创建播放视频的 Controller
    lazy var playContr: BQPlayViewController = {
        let playContr: BQPlayViewController = self.storyboard?.instantiateViewController(withIdentifier: BQPlayViewController.nameOfClass) as! BQPlayViewController
        playContr.view.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        playContr.delegate = self
        return playContr
    } ()
    
    // MARK: - BQPlayViewControllerDelegate
    func didFullScreen() {
    }
    
    // MARK: - LifyCyle
    override class func initialize() {
        // NavigationBar color and shadow
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = kSchemeColor
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = kSchemeColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(statusBar)
            window.addSubview(playContr.view)
        }
    }
}
