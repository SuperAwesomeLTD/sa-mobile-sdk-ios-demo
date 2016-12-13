//
//  SATabBarController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class SATabBarController: UITabBarController {
    
    // tab bar items
    var firstVCTabBarItem: UIButton!
    var secondVCTabBarItem: UIButton!
    
    // red view
    var firstRect: CGRect?
    var secondRect: CGRect?
    var redView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstVCTabBarItem = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        firstVCTabBarItem.addTarget(self, action: #selector(firstItemAction), for: .touchUpInside)
        firstVCTabBarItem.setTitle("tab_bar_demo_formats".localized.uppercased(), for: .normal)
        firstVCTabBarItem.backgroundColor = UIColor.black
        firstVCTabBarItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        secondVCTabBarItem = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        secondVCTabBarItem.addTarget(self, action: #selector(secondItemAction), for: .touchUpInside)
        secondVCTabBarItem.setTitle("tab_bar_user_placement".localized.uppercased(), for: .normal)
        secondVCTabBarItem.backgroundColor = UIColor.black
        secondVCTabBarItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        redView = UIView()
        redView.backgroundColor = UIColorFromHex(0xE30716)
        
        tabBar.addSubview(firstVCTabBarItem)
        tabBar.addSubview(secondVCTabBarItem)
        tabBar.addSubview(redView)
        
        rearrangeSubviews(frame: tabBar.frame)
        firstItemAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func rearrangeSubviews (frame: CGRect) {
        // data
        let half = frame.width / 2
        
        firstRect = CGRect(x: 0, y: frame.height - 5, width: half - 1, height: 5)
        secondRect = CGRect(x: half, y: frame.height - 5, width: half, height: 5)
        
        firstVCTabBarItem.frame = CGRect(x: 0, y: 0, width: half, height: frame.height)
        secondVCTabBarItem.frame = CGRect(x: half, y: 0, width: half, height: frame.height)
        redView.frame = firstRect!
    }
    
    func firstItemAction () {
        firstVCTabBarItem.setTitleColor(UIColor.white, for: .normal)
        secondVCTabBarItem.setTitleColor(UIColorFromHex(0xC8C8C8), for: .normal)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.redView.frame = self.firstRect!
        })
        
        if let vcs = self.viewControllers {
            self.selectedViewController = vcs[0]
        }
    }
    
    func secondItemAction () {
        firstVCTabBarItem.setTitleColor(UIColorFromHex(0xC8C8C8), for: .normal)
        secondVCTabBarItem.setTitleColor(UIColor.white, for: .normal)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.redView.frame = self.secondRect!
        })
        
        if let vcs = self.viewControllers {
            self.selectedViewController = vcs[1]
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return .portrait
        }
    }
}
