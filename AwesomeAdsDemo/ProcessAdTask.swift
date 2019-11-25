//
//  ProcessAdTask.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import SuperAwesome
import RxSwift

class ProcessAdTask: Task {

    typealias Input = ProcessAdRequest
    typealias Output = SAResponse
    typealias Result = Single<Output>
    
    func execute(withInput input: ProcessAdRequest) -> Single<SAResponse> {
        
        let payload = input.ad.jsonPreetyStringRepresentation()
        let testPlacement = 10000;
        let loader: SALoader = SALoader ()
        let session: SASession = SASession ()
        
        return Single.create { subscriber -> Disposable in
            
            loader.processAd(testPlacement, andData: payload, andStatus: 200, andSession: session, andResult: { (response: SAResponse?) in
                
                if let response = response, response.isValid () {
                    
                    (response.ads?.firstObject as? SAAd)?.isPadlockVisible = true
                    
                    subscriber(.success(response))
                }
                else {
                    subscriber(.error(AAError.ParseError))
                }
            })

            return Disposables.create()
        }
        
    }
}
