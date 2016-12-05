//
//  AdRx.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 30/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SuperAwesome

extension SABannerAd {
    
    func loadRx (_ placementId: Int) -> Observable<SAEvent> {
        
        // create a new observable
        return Observable.create({ (observer) -> Disposable in
            
            // set a callback to catch the load process happening and send
            // observer events
            self.setCallback({ (placementId: Int, event: SAEvent) in
                observer.onNext(event)
                observer.onCompleted()
            })
            
            // load ad for placement ID
            self.load(placementId)
            
            
            // return
            return Disposables.create()
        })
        
    }
}

extension SAInterstitialAd {
    
    class func loadRx (_ placementId: Int) -> Observable<SAEvent> {
        
        // create a new observable
        return Observable.create({ (observer) -> Disposable in
            
            // set a callback to catch the load process happening and send
            // observer events
            SAInterstitialAd.setCallback({ (placementId: Int, event: SAEvent) in
                observer.onNext(event)
                observer.onCompleted()
            })
            
            // load ad for placement ID
            SAInterstitialAd.load(placementId)
            
            
            // return
            return Disposables.create()
        })
        
    }
    
}

extension SAVideoAd {
    
    class func loadRx (_ placementId: Int) -> Observable<SAEvent> {
        
        // create a new observable
        return Observable.create({ (observer) -> Disposable in
            
            // set a callback to catch the load process happening and send
            // observer events
            SAVideoAd.setCallback({ (placementId: Int, event: SAEvent) in
                observer.onNext(event)
                observer.onCompleted()
            })
            
            // load ad for placement ID
            SAVideoAd.load(placementId)
            
            
            // return
            return Disposables.create()
        })
        
    }
    
}

extension SAAppWall {
    
    class func loadRx (_ placementId: Int) -> Observable<SAEvent> {
        
        // create a new observable
        return Observable.create({ (observer) -> Disposable in
            
            // set a callback to catch the load process happening and send
            // observer events
            SAAppWall.setCallback({ (placementId: Int, event: SAEvent) in
                observer.onNext(event)
                observer.onCompleted()
            })
            
            // load ad for placement ID
            SAAppWall.load(placementId)
            
            
            // return
            return Disposables.create()
        })
        
    }
    
}
