//
//  NetworkTask.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import Foundation
import RxSwift
import SANetworking

class NetworkTask: Task {

    typealias Input = NetworkRequest
    typealias Output = String
    typealias Result = Single<Output>
    
    func execute(withInput input: NetworkRequest) -> Single<String> {
        
        let network = SANetwork ()
        
        return Single<String>.create { subscriber -> Disposable in
         
            if input.method == .POST {
                
                network.sendPOST(input.endpoint, withQuery: input.query, andHeader: input.headers, andBody: input.body){ status, payload, success in
                    
                    if let payload = payload, status == 200 {
                        subscriber(.success(payload))
                    } else {
                        subscriber(.error(input.error))
                    }
                }
            }
            else {
                
                network.sendGET(input.endpoint, withQuery: input.query, andHeader: input.headers) { status, payload, success in
                    
                    if let payload = payload, status == 200 {
                        subscriber(.success(payload))
                    } else {
                        subscriber(.error(input.error))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
