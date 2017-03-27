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
import SANetworking
import SAModelSpace

extension SuperAwesome {
    
    enum CreativesError : Error {
        case InvalidData
        case NoResults
    }
    
    static func loadCreatives (placementId: Int) -> Observable<SACreative> {
        
        let session = SASession ()
        let url = session.getBaseUrl() + "/ad/\(placementId)"
        let query:[String : Any] = [
            "debug": "json",
            "forceCreative": 1,
            "jwtToken": LoginManager.sharedInstance.getLoggedUserToken()
        ]
        
        let network = SANetwork()
        
        return Observable.create({ (subscriber) -> Disposable in
            
            network.sendGET(url, withQuery: query, andHeader: [:]) { (status, payload, success) in
                
                var results: [SACreative] = []
                
                if let payload = payload, let data = payload.data(using: .utf8) {
                    
                    do {
                        let bigJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        if let allCreatives = bigJson?["allCreatives"] as? [[String:Any]] {
                            
                            for dict in allCreatives {
                                if let creative = SACreative(jsonDictionary: dict) {
                                    results.append(creative)
                                }
                            }
                            
                        }
                        
                    } catch {
                        subscriber.onError(CreativesError.InvalidData)
                    }
                } else {
                    subscriber.onError(CreativesError.InvalidData)
                }
                
                if (results.count == 0) {
                    subscriber.onError(CreativesError.NoResults)
                }
                else {
                
                    for result in results {
                        subscriber.onNext(result)
                    }
                    subscriber.onCompleted()
                }
            }
            
            return Disposables.create()
        })
    }
    
}

extension SABannerAd {
    
    func loadRx (_ placementId: Int) -> Observable<SAEvent> {
        
        // create a new observable
        return Observable.create({ (observer) -> Disposable in
            
            // set a callback to catch the load process happening and send
            // observer events
            self.setCallback({ (placementId: Int, event: SAEvent) in
                observer.onNext(event)
                
                if (event == .adLoaded) {
                    observer.onCompleted()
                }
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
                
                if (event == .adLoaded) {
                    observer.onCompleted()
                }
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
                
                if (event == .adLoaded) {
                    observer.onCompleted()
                }
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
                
                if (event == .adLoaded) {
                    observer.onCompleted()
                }
            })
            
            // load ad for placement ID
            SAAppWall.load(placementId)
            
            
            // return
            return Disposables.create()
        })
        
    }
    
}
