//
//  Extensions.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

extension ObservableType {
    
    public func catchErrorAndContinue(handler: @escaping (Error) throws -> Void) -> RxSwift.Observable<Self.E> {
        
        return self
            .catchError { error in
                try handler(error)
                return Observable.error(error)
            }
            .retry()
    }
    
    public func subscribeNext (handler: @escaping (Self.E) -> Void) -> Disposable {
        return self.subscribe(onNext: handler)
    }
}
