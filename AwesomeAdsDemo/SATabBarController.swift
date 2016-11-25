//
//  SATabBarController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

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
        firstVCTabBarItem.setTitle("Demo formats".uppercased(), for: .normal)
        firstVCTabBarItem.backgroundColor = UIColor.black
        firstVCTabBarItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        secondVCTabBarItem = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        secondVCTabBarItem.addTarget(self, action: #selector(secondItemAction), for: .touchUpInside)
        secondVCTabBarItem.setTitle("Your placement".uppercased(), for: .normal)
        secondVCTabBarItem.backgroundColor = UIColor.black
        secondVCTabBarItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        redView = UIView()
        redView.backgroundColor = SAColor(red: 227, green: 7, blue: 22)
        
        tabBar.addSubview(firstVCTabBarItem)
        tabBar.addSubview(secondVCTabBarItem)
        tabBar.addSubview(redView)
        
        rearrangeSubviews(frame: tabBar.frame)
        firstItemAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let frame = CGRect(x: 0, y: size.height - tabBar.frame.size.height, width: size.width, height: tabBar.frame.height)
        rearrangeSubviews(frame: frame)
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
        secondVCTabBarItem.setTitleColor(SAColor(red: 200, green: 200, blue: 200), for: .normal)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.redView.frame = self.firstRect!
        })
        
        if let vcs = self.viewControllers {
            self.selectedViewController = vcs[0]
        }
    }
    
    func secondItemAction () {
        firstVCTabBarItem.setTitleColor(SAColor(red: 200, green: 200, blue: 200), for: .normal)
        secondVCTabBarItem.setTitleColor(UIColor.white, for: .normal)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.redView.frame = self.secondRect!
        })
        
        if let vcs = self.viewControllers {
            self.selectedViewController = vcs[1]
        }
    }
}
