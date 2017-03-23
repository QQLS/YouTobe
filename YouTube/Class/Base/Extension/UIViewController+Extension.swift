//
//  UIViewController+Extension.swift
//  YouTube
//
//  Created by xiupai on 2017/3/15.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     直接加载 xib，创建 ViewController
     
     - returns: UIViewController
     */
    class func initFromNib() -> UIViewController {
        guard Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil else {
            assertionFailure("Invalid parameter")
            return UIViewController()
        }
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }
    
    public static var topViewController: UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return presentedVC
    }
    
    fileprivate func ts_pushViewController(_ viewController: UIViewController, animated: Bool, hideTabbar: Bool) {
        viewController.hidesBottomBarWhenPushed = hideTabbar
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /**
     push
     */
    public func ts_pushAndHideTabbar(_ viewController: UIViewController) {
        ts_pushViewController(viewController, animated: true, hideTabbar: true)
    }
    
    /**
     present
     */
    public func ts_presentViewController(_ viewController: UIViewController, completion:(() -> Void)?) {
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: completion)
    }
}

