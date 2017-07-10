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
    
    static func getCompany(forId id: Int, andJWTToken jwtToken: String) -> Single<Company> {
        
        let operation = NetworkOperation.getCompany(forId: id, andJWTToken: jwtToken)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<Company> in
                let task = ParseTask<Company>()
                return task.execute(withInput: rawData)
            }
    }
    
    static func getCompanies(forJWTToken jwtToken: String) -> Single<[Company]> {
     
        if DataStore.shared.companies.count > 0 {
            return Single.just(DataStore.shared.companies)
        }
        
        let operation = NetworkOperation.getCompanies(forJWTToken: jwtToken)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<NetworkData<Company>> in
                
                let task = ParseTask<NetworkData<Company>>()
                return task.execute(withInput: rawData)
            }
            .map { data -> [Company] in
                return data.data
            }
            .do(onNext: { data in
                DataStore.shared.companies = data
            })
    }
}
