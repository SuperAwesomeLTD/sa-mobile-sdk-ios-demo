//
//  AdPreload.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SAAdLoader
import SuperAwesome
import SASession

class AdPreload: NSObject {

    func loadAd (placementId: Int, test: Bool) -> Observable <AdFormat> {
        
        let session = SASession ()
        if (test) {
            session.enableTestMode()
        }
        let loader = SALoader ()
        
        return Observable.create({ (observer) -> Disposable in
            
            loader.loadAd(placementId, with: session) { response in
                
                let format: AdFormat = AdFormat.fromResponse(response)
                observer.onNext(format)
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
}
