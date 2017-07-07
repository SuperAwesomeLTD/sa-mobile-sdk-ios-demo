//
//  Workers+Company.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

extension UserWorker {
    
    static func getCompany () -> Single<Company> {
     
        let jwtToken = DataStore.shared.jwtToken
        
        return getProfile(forToken: jwtToken!)
            .flatMap { profile -> Single<String> in
             
                let operation = NetworkOperation.getApps(forCompany: profile.companyId!, andJWTToken: jwtToken!)
                let request = NetworkRequest(withOperation: operation)
                let task = NetworkTask()
                return task.execute(withInput: request)
            }
            .flatMap { rawData -> Single<Company> in
                
                let task = ParseTask<Company>()
                return task.execute(withInput: rawData)
            }
    }
}
