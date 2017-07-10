//
//  Workers+Companies.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

extension UserWorker {
    
    static func getCompanies(forJWTToken jwtToken: String) -> Single<NetworkData<Company>> {
     
        let operation = NetworkOperation.getCompanies(forJWTToken: jwtToken)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<NetworkData<Company>> in
                
                let task = ParseTask<NetworkData<Company>>()
                return task.execute(withInput: rawData)
            }
            .do(onNext: { data in
                DataStore.shared.companies = data.data
            })
    }
}
