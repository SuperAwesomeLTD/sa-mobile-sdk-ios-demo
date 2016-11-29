//
//  DisplayController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SuperAwesome

class DisplayController: SABaseViewController {

    @IBOutlet weak var normalAndSmallBanner: SABannerAd!
    @IBOutlet weak var mpuBanner: SABannerAd!
    @IBOutlet weak var bigBanner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare view controller
        self.makeSASmallNavigationController(withTitle: "Display Ad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
