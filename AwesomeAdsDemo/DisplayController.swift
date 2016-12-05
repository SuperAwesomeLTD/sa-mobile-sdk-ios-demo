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

    // outlets
    @IBOutlet weak var normalAndSmallBanner: SABannerAd!
    @IBOutlet weak var mpuBanner: SABannerAd!
    @IBOutlet weak var bigBanner: SABannerAd!
    
    // other vars needed
    var headerTitle: String = "Ad Unit"
    var placementId: Int = 0
    var test: Bool = false
    var format: AdFormat = .unknown
    var parentalGate: Bool = false
    var bgColor: Bool = false
    var loadHappened: Bool = false
    
    // observable
    var formatSubject: PublishSubject<AdFormat>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the controller nav ba & title
        self.makeSASmallNavigationController()
        self.setSASmallNavigationControllerTitle(headerTitle)
        
        // create the observable that will fire just once
        formatSubject = PublishSubject()
        
        // handle the smallbanner & normalbanner cases
        formatSubject
            .asObservable()
            .subscribe(onNext: { (format) in
              
                switch format {
                case .smallbanner, .normalbanner:
                    
                    self.normalAndSmallBanner.setParentalGate(self.parentalGate)
                    self.normalAndSmallBanner.setColor(self.bgColor)
                    self.normalAndSmallBanner.setTestMode(self.test)
                    
                    self.normalAndSmallBanner.loadRx(self.placementId)
                        .filter({ (event) -> Bool in
                            return event == .adLoaded
                        })
                        .subscribe(onNext: { (event) in
                            self.normalAndSmallBanner.play()
                        })
                        .addDisposableTo(self.disposeBag)
                    
                    break
                case .mpu:
                    
                    self.mpuBanner.setParentalGate(self.parentalGate)
                    self.mpuBanner.setColor(self.bgColor)
                    self.mpuBanner.setTestMode(self.test)
                    
                    self.mpuBanner.loadRx(self.placementId)
                        .filter({ (event) -> Bool in
                            return event == .adLoaded
                        })
                        .subscribe(onNext: { (event) in
                            self.mpuBanner.play()
                        })
                        .addDisposableTo(self.disposeBag)
                    
                    break
                case .bigbanner:
                    
                    self.bigBanner.setParentalGate(self.parentalGate)
                    self.bigBanner.setColor(self.bgColor)
                    self.bigBanner.setTestMode(self.test)
                    
                    self.bigBanner.loadRx(self.placementId)
                        .filter({ (event) -> Bool in
                            return event == .adLoaded
                        })
                        .subscribe(onNext: { (event) in
                            self.bigBanner.play()
                        })
                        .addDisposableTo(self.disposeBag)
                    
                    break
                default:break
                }
                
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // call super
        super.viewDidAppear(animated)
        
        // publish a subject with format (because now it's safe to display
        // banner ads that othervise might be affected by weird behaviour)
        formatSubject.on(.next(format))
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
}
