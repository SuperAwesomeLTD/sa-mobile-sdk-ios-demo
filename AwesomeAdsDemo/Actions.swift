//
//  Actions.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

func checkIsUserLoggedInAction () -> Observable<Event> {
    
    let token = UserDefaults.standard.string(forKey: "jwtToken")
    
    guard let jwtToken = token else {
        return Observable.just(NoJwtTokenFoundEvent())
    }
    
    return Observable.just(JwtTokenFoundEvent(jwtToken: jwtToken))
}

func loginUserAction(withUsername username: String, andPassword password: String) -> Observable<Event> {
    
    let operation = NetworkOperation.login(forUsername: username, andPassword: password)
    let request = NetworkRequest(withOperation: operation)
    let task = NetworkTask()
    return task.execute(withInput: request)
        .flatMap { rawData -> Single<LogedUser> in
            let task = ParseTask<LogedUser>()
            return task.execute(withInput: rawData)
        }
        .map { loggedUser -> String? in
            return loggedUser.token
        }
        .asObservable()
        .flatMap{ (token: String?) -> Observable<Event> in
            
            guard let token = token else {
                return Observable.just(ErrorTryingGetJwtTokenEvent(error: AAError.ParseError))
            }
            
            return Observable.just(JwtTokenFoundEvent(jwtToken: token))
            
        }
        .catchError { error -> Observable<Event> in
            return Observable.just(ErrorTryingGetJwtTokenEvent(error: AAError.LoginFailed))
        }
    
}
