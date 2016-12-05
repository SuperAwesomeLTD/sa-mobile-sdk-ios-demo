//
//  UIViewController+SANavigationBar.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension SABaseViewController {
    
    func makeSABigNavigationController () {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: false)
            let navigation = SABigNavigationBar()
            self.view.addSubview(navigation)
        }
    }
    
    func makeSASmallNavigationController () {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: false)
            let navigation = SASmallNavigationBar()
            if let close = navigation.closeBtn {
                close.rx.tap
                    .subscribe(onNext: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo(disposeBag)
            }
            self.view.addSubview(navigation)
        }
    }
    
    func setSASmallNavigationControllerTitle (_ title: String) {
        for v in self.view.subviews {
            if let v = v as? SASmallNavigationBar {
                v.setTitle(title)
            }
        }
    }
}

class SANavigationController : UINavigationController {
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
