//
//  DemoFormatsProvider.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DemoFormatsProvider: NSObject {

    func getDemoFormats () -> Observable <DemoFormatsViewModel> {
        return Observable.create({ (observer) -> Disposable in
            
            let data: [DemoFormatsViewModel] = [
                DemoFormatsViewModel(placementId: 30472, image: "smallbanner", name: "Mobile Small Leaderboard", details: "Size: 300x50"),
                DemoFormatsViewModel(placementId: 30471, image: "banner", name: "Mobile Leaderboard", details: "Size: 320x50"),
                DemoFormatsViewModel(placementId: 30475, image: "leaderboard", name: "Tablet Leaderboard", details: "Size: 728x90"),
                DemoFormatsViewModel(placementId: 30476, image: "mpu", name: "Tablet MPU", details: "Size: 300x250"),
                DemoFormatsViewModel(placementId: 30473, image: "small_inter_port", name: "Mobile Interstitial Portrait", details: "320x480"),
                DemoFormatsViewModel(placementId: 30474, image: "small_inter_land", name: "Mobile Interstitial Landscape", details: "Size: 480x320"),
                DemoFormatsViewModel(placementId: 30477, image: "large_inter_port", name: "Tablet Interstitial Portrait", details: "Size: 768x1024"),
                DemoFormatsViewModel(placementId: 30478, image: "large_inter_land", name: "Tablet Interstitial Landscape", details: "Size: 1024x768"),
                DemoFormatsViewModel(placementId: 30479, image: "video", name: "Mobile Video", details: "Size: 600x480")
            ]
            
            for d in data {
                observer.onNext(d)
            }
            observer.onCompleted()
            
            return Disposables.create()
        })
    }
    
}
