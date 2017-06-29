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
import SAModelSpace

class DisplayController: SABaseViewController {

    @IBOutlet weak var normalAndSmallBanner: SABannerAd!
    @IBOutlet weak var mpuBanner: SABannerAd!
    @IBOutlet weak var bigBanner: SABannerAd!
    @IBOutlet weak var titleText: UILabel!
    
    var response: SAResponse?
    var parentalGate: Bool = false
    var bgColor: Bool = false
    var format: AdFormat = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "Display Ads".localized
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let ad: SAAd = response?.ads.object(at: 0) as! SAAd
        
        switch format {
        case .smallbanner, .normalbanner:
            normalAndSmallBanner.setParentalGate(parentalGate)
            normalAndSmallBanner.setColor(bgColor)
            normalAndSmallBanner.setAd(ad)
            normalAndSmallBanner.play()
            break
        case .bigbanner:
            bigBanner.setParentalGate(parentalGate)
            bigBanner.setColor(bgColor)
            bigBanner.setAd(ad)
            bigBanner.play()
            break
        case .mpu:
            mpuBanner.setParentalGate(parentalGate)
            mpuBanner.setColor(bgColor)
            mpuBanner.setAd(ad)
            mpuBanner.play()
            break
        default:break
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
