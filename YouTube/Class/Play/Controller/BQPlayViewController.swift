//
//  BQPlayViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = BQPlayVideoCell.nameOfClass

enum PlayViewControllerState {
    case minimize
    case maximize
    case hidden
}

protocol BQPlayViewControllerDelegate: class {
    func didMaximize()
    func didMinimize()
    func swipe(to state: PlayViewControllerState, translation: CGFloat)
    func didEndSwipe(to state: PlayViewControllerState)
}

class BQPlayViewController: UIViewController {
    
    enum PanDirection {
        case up
        case left
        case none
    }
    
    weak var delegate: BQPlayViewControllerDelegate?
    var video: BQVideoModel?
    var state: PlayViewControllerState = .hidden
    var direction: PanDirection = .none
    var videoPlayer = AVPlayer()
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var headerView: BQPlayVideoHeader!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var minimizeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(BQPlayViewController.show(notification:)), name: NSNotification.Name(PlayChangeNotification), object: nil)
    }
    
    // MARK: - Action
    @IBAction func tapPlayView(_ sender: UITapGestureRecognizer?) {
        videoPlayer.play()
        state = .maximize
        delegate?.didMaximize()
        animate()
    }
    
    @IBAction func minimizeAction(_ sender: UIButton) {
        state = .minimize
        delegate?.didMinimize()
        animate()
    }
    
    @IBAction func minimizePanAction(_ sender: UIPanGestureRecognizer) {
        // 更改控件的透明度和大小
        func changeScaleSize(with factor: CGFloat) {
            minimizeBtn.alpha = 1 - factor
            tableView.alpha = 1 - factor
            let scale = CGAffineTransform(scaleX: 1 - 0.5 * factor, y: 1 - 0.5 * factor)
            print(playView.bounds, playView.frame)
            let translation = CGAffineTransform(translationX: -(playView.bounds.width / 4 * factor), y: -(playView.bounds.height / 4 * factor))
            playView.transform = scale.concatenating(translation)
        }
        
        if .began == sender.state {
            // 判断方向
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                direction = .up
            } else {
                direction = .left
            }
        }
        
        var finalState: PlayViewControllerState = .maximize
        let translation = sender.translation(in: nil)
        switch state {
        case .maximize: // maximize -> minimize
            if translation.y <= 0 { // 已经全屏之后不能再往上滑动
                return
            }
            let factor = abs(translation.y) / kScreenHeight
            changeScaleSize(with: factor)
            delegate?.swipe(to: .minimize, translation: factor)
            finalState = .minimize
        case .minimize:
            if .left == direction {
                if translation.x < 0 {
                    let factor = abs(translation.x)
                    delegate?.swipe(to: .hidden, translation: factor)
                    finalState = .hidden
                }
            } else if .up == direction {
                let factor = 1 - abs(translation.y) / kScreenHeight
                changeScaleSize(with: factor)
                delegate?.swipe(to: .maximize, translation: factor)
                finalState = .maximize
            }
        case .hidden: break
        }
        
        if .ended == sender.state {
            state = finalState
            animate()
            delegate?.didEndSwipe(to: finalState)
            
            if .hidden == finalState {
                videoPlayer.pause()
            }
        }
    }
    
    func show(notification: Notification) {
        BQVideoModel.fetchVideoList(with: URLLink.video.link()) { (response) in
            self.video = response
            
            guard let url = response?.videoLink?.url else { return }
            self.videoPlayer = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: self.videoPlayer)
            playerLayer.frame = self.playView.bounds
            self.playView.layer.insertSublayer(playerLayer, below: self.minimizeBtn.layer)
            if .hidden != self.state {
                self.videoPlayer.play()
            }
            
            self.headerView.video = response
            self.tableView.reloadData()
        }
        
        tapPlayView(nil)
    }
    
    private func animate() {
        switch state {
        case .maximize:
            UIView.animate(withDuration: 0.25, animations: { 
                self.minimizeBtn.alpha = 1
                self.tableView.alpha = 1
                self.playView.transform = .identity
                UIApplication.shared.isStatusBarHidden = true
            }, completion: { (isStop) in
            })
        case .minimize:
            UIView.animate(withDuration: 0.25, animations: { 
                self.minimizeBtn.alpha = 0
                self.tableView.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let translation = CGAffineTransform.init(translationX: -self.playView.bounds.width / 4, y: -self.playView.bounds.height / 4)
                self.playView.transform = scale.concatenating(translation)
                UIApplication.shared.isStatusBarHidden = false
            }, completion: { (isStop) in
            })
        case .hidden:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension BQPlayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = video?.suggestedVideos?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? BQPlayVideoCell,
            let count = video?.suggestedVideos?.count,
            indexPath.item < count else {
            return UITableViewCell()
        }
        
        cell.video = video?.suggestedVideos![indexPath.item]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BQPlayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
    }
}
