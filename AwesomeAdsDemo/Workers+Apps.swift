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
    
    static func getApps(forCompany id: Int, andToken jwtToken: String) -> Single<NetworkData<App>> {
        
        let operation = NetworkOperation.getApps(forCompany: id, andJWTToken: jwtToken)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<NetworkData<App>> in
                
                let task = ParseTask<NetworkData<App>>()
                return task.execute(withInput: rawData)
            }
    }
}
