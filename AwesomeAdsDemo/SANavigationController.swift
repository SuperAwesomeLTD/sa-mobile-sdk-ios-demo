//
//  UIViewController+SANavigationBar.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeSABigNavigationController () {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: false)
            let navigation = SABigNavigationBar()
            self.view.addSubview(navigation)
        }
    }
    
    func makeSASmallNavigationController (_ title: String) {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: false)
            let navigation = SASmallNavigationBar(title)
            if let close = navigation.closeBtn {
                close.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
            }
            self.view.addSubview(navigation)
        }
    }
    
    func closeViewController () {
        // not implemented
    }
}
