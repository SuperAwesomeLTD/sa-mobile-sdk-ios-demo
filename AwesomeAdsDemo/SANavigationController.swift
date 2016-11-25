//
//  UIViewController+SANavigationBar.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeSANavigationController () {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navigation: SANavigationBar = SANavigationBar()
        self.view.addSubview(navigation)
    }
}
