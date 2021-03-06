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
    @IBOutlet weak var bigBanner: SABannerAd!
    @IBOutlet weak var titleText: UILabel!
    
    var response: SAResponse?
    var parentalGate: Bool = false
    var bumperPage: Bool = false
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
        case .smallbanner, .banner:
            normalAndSmallBanner.disableMoatLimiting()
            normalAndSmallBanner.setBumperPage(bumperPage)
            normalAndSmallBanner.setParentalGate(parentalGate)
            normalAndSmallBanner.setColor(bgColor)
            normalAndSmallBanner.setAd(ad)
            normalAndSmallBanner.play()
            break
        case .smallleaderboard, .leaderboard, .pushdown, .billboard:
            bigBanner.disableMoatLimiting()
            bigBanner.setBumperPage(bumperPage)
            bigBanner.setParentalGate(parentalGate)
            bigBanner.setColor(bgColor)
            bigBanner.setAd(ad)
            bigBanner.play()
            break
        case .mpu, .doublempu, .skinnysky, .sky:
            mpuBanner.disableMoatLimiting()
            mpuBanner.setBumperPage(bumperPage)
            mpuBanner.setParentalGate(parentalGate)
            mpuBanner.setColor(bgColor)
            mpuBanner.setAd(ad)
            mpuBanner.play()
            break
        default:break
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
