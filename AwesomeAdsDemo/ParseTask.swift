//
//  ParseTask.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class ParseTask <T : Mappable>: Task {

    typealias Input = String
    typealias Output = T
    typealias Result = Single<T>
    
    func execute(withInput input: String) -> Single<T> {
        
        return Single<T>.create { single -> Disposable in
            
            if let parsed = T(JSONString: input) {
                single(.success(parsed))
            } else {
                single(.error(AAError.ParseError))
            }
            
            return Disposables.create()
        }
    }
}
