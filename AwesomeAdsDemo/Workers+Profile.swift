//
//  Workers+Profile.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

//
// get the profile
extension UserWorker {
    
    static func getProfile (forToken jwtToken: String) -> Single<UserProfile> {
        
        if let profile = DataStore.shared.profile {
            return Single.just(profile)
        }
        
        let operation = NetworkOperation.getProfile(forJWTToken: jwtToken)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<UserProfile> in
                let task = ParseTask<UserProfile>()
                return task.execute(withInput: rawData)
            }
            .do(onNext: { profile in
                DataStore.shared.profile = profile
            })
    }
}
