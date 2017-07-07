//
//  Workers+Login.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

//
// check if user is logged in
extension UserWorker {
    
    static func isUserLoggedIn () -> Single<Void> {
        
        return Single<Void>.create { single -> Disposable in
            
            if let jwtToken = DataStore.shared.jwtToken,
               let metadata = UserMetadata.processMetadata(jwtToken: jwtToken),
               metadata.isValid {
                
                single(.success(()))
            }
            else {
                single(.error(AAError.SessionExpired))
            }
            
            return Disposables.create()
        }
    }
}

//
// login user
extension UserWorker {
    
    static func login(userWithUsername username: String, andPassword password: String) -> Single<LogedUser> {
        
        let operation = NetworkOperation.login(forUsername: username, andPassword: password)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<LogedUser> in
                
                let task = ParseTask<LogedUser>()
                return task.execute(withInput: rawData)
            }
            .do(onNext: { logedUser in
                DataStore.shared.jwtToken = logedUser.token
            })
    }
}
