//
//  BQPlayViewController.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol BQPlayViewControllerDelegate: class {
    func didFullScreen()
}

class BQPlayViewController: UIViewController {
    
    weak var delegate: BQPlayViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
