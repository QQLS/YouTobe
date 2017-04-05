//
//  BQNavigationController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

class BQNavigationController: UINavigationController {
    
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
        let x = -kScreenWidth
        let y = UIScreen.main.bounds.height - (kScreenWidth / 2 * (9.0 / 16)) - 10
        return CGPoint.init(x: x, y: y)
    } ()
    let minimizeOrigin: CGPoint = {
        let x = kScreenWidth / 2 - 10
        let y = kScreenHeight - (kScreenWidth / 2 * (9.0 / 16)) - 10
        return CGPoint.init(x: x, y: y)
    } ()
    let maximizeOrigin: CGPoint = CGPoint.zero
    
    // 创建播放视频的 Controller
    lazy var playContr: BQPlayViewController = {
        let playContr: BQPlayViewController = self.storyboard?.instantiateViewController(withIdentifier: BQPlayViewController.nameOfClass) as! BQPlayViewController
        playContr.view.frame = CGRect.init(origin: self.hiddenOrigin, size: kScreenBounds.size)
        playContr.delegate = self
        return playContr
    } ()
    
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

// MARK: - BQPlayViewControllerDelegate
extension BQNavigationController: BQPlayViewControllerDelegate {
    
    func animatePlayView(to state: PlayViewControllerState) {
        switch state {
        case .maximize:
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .beginFromCurrentState, animations: { 
                self.playContr.view.frame.origin = self.maximizeOrigin
            })
        case .minimize:
            UIView.animate(withDuration: 0.25, animations: { 
                self.playContr.view.frame.origin = self.minimizeOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.25, animations: { 
                self.playContr.view.frame.origin = self.hiddenOrigin
            })
        }
    }
    
    func didMaximize() {
        animatePlayView(to: .maximize)
    }
    
    func didMinimize() {
        animatePlayView(to: .minimize)
    }
    
    func swipe(to state: PlayViewControllerState, translation: CGFloat) {
        // 计算手势滑动的过程中 playView 的起点
        func originOfPlayViewTo(scale factor: CGFloat) -> CGPoint {
            // 真正偏移量
            let playViewMarginW = kScreenWidth * 0.5 * factor
            let playViewMarginH = playViewMarginW * (9.0 / 16)
            let x = (kScreenWidth - 10) * factor - playViewMarginW
            let y = (kScreenHeight - 10) * factor - playViewMarginH
            return CGPoint(x: x, y: y)
        }
        
        switch state {
        case .maximize, .minimize:
            self.playContr.view.origin = originOfPlayViewTo(scale: translation)
        case .hidden:
            self.playContr.view.origin.x = kScreenWidth / 2 - translation - 10
        }
    }
    
    func didEndSwipe(to state: PlayViewControllerState) {
        animatePlayView(to: state)
    }
}
