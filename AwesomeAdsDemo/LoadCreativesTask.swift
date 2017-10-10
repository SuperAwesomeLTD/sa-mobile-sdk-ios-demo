//
//  LoadCreativesTask.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import SAModelSpace
import SASession
import SANetworking

class LoadCreativesTask: Task  {
    
    typealias Input = LoadCreativesRequest
    typealias Output = SACreative
    typealias Result = Observable<SACreative>
    
    func execute(withInput input: LoadCreativesRequest) -> Observable<SACreative> {
        
        let session = SASession ()
        let url = session.getBaseUrl() + "/ad/\(input.placementId)"
        let query:[String : Any] = [
            "debug": "json",
            "forceCreative": 1,
            "jwtToken": input.token
        ]
        let header:[String:Any] = [
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
        ]
        
        let network = SANetwork()
        
        return Observable.create { subscriber -> Disposable in
            
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
                        subscriber.onError(AAError.NoInternet)
                    }
                } else {
                    subscriber.onError(AAError.NoInternet)
                }
                
                if (results.count == 0) {
                    subscriber.onError(AAError.ParseError)
                }
                else {
                    
                    for result in results {
                        subscriber.onNext(result)
                    }
                    subscriber.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
