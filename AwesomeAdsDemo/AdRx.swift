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
import SAAdLoader
import SASession

extension SALoader {
    
    enum SAError : Error {
        case InvalidData
        case NoResults
        case NoAdData
    }
    
    static func loadCreatives (placementId: Int) -> Observable<SACreative> {
        
        let session = SASession ()
        let url = session.getBaseUrl() + "/ad/\(placementId)"
        let query:[String : Any] = [
            "debug": "json",
            "forceCreative": 1,
            "jwtToken": DataStore.shared.jwtToken!
        ]
        let header:[String:Any] = [
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
        ]
        
        let network = SANetwork()
        
        return Observable.create({ (subscriber) -> Disposable in
            
            network.sendGET(url, withQuery: query, andHeader: header) { (status, payload, success) in
                
                var results: [SACreative] = []
                
                if let payload = payload, let data = payload.data(using: .utf8) {
                    
                    do {
                        let bigJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        if let allCreatives = bigJson?["allCreatives"] as? [[String:Any]] {
                            
                            for dict in allCreatives {
                                if let creative = SACreative(jsonDictionary: dict) {
                                    if creative.clickUrl == nil, let click = dict["clickUrl"] as? String {
                                        creative.clickUrl = click
                                    }
                                    results.append(creative)
                                }
                            }
                            
                        }
                        
                    } catch {
                        subscriber.onError(SAError.InvalidData)
                    }
                } else {
                    subscriber.onError(SAError.InvalidData)
                }
                
                if (results.count == 0) {
                    subscriber.onError(SAError.NoResults)
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
    
    static func loadTestAd (placementId: Int) -> Observable<SAAd> {
        
        let loader: SALoader = SALoader ()
        let session: SASession = SASession ()
        session.enableTestMode()
        
        return Observable.create({ (subscriber) -> Disposable in
            
            loader.loadAd(placementId, with: session) { (response: SAResponse?) in
                
                if let response = response, response.isValid (), let ad = response.ads.object(at: 0) as? SAAd  {
                    subscriber.onNext(ad)
                    subscriber.onCompleted()
                }
                else {
                    subscriber.onError(SAError.NoAdData)
                }
                
            }
            
            return Disposables.create()
        })
    }
    
    static func processAd (ad: SAAd) -> Observable <SAResponse> {
        
        let payload = ad.jsonPreetyStringRepresentation()
        let testPlacement = 10000;
        let loader: SALoader = SALoader ()
        let session: SASession = SASession ()
        
        return Observable.create({ (subscriber) -> Disposable in
            
            loader.processAd(testPlacement, andData: payload, andStatus: 200, andSession: session, andResult: { (response: SAResponse?) in
                
                if let response = response, response.isValid () {
                    subscriber.onNext(response)
                    subscriber.onCompleted()
                }
                else {
                    subscriber.onError(SAError.NoAdData)
                }
                
            })
            
            return Disposables.create()
        })
        
    }
    
}
