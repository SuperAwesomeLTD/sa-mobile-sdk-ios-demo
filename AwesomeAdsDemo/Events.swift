//
//  Events.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

enum Event {
    case LoadingJwtToken
    case GotJwtToken(token: String)
    case NoJwtToken
    case JwtTokenError(error: AAError)
    case GotUserProfile(profile: UserProfile)
    case UserProfileError
}

extension Event {
    static func checkIsUserLoggedIn () -> Observable<Event> {
        
        let token = UserDefaults.standard.string(forKey: "jwtToken")
        
        guard let jwtToken = token else {
            return Observable.just(Event.NoJwtToken)
        }
        
        return Observable.just(Event.GotJwtToken(token: jwtToken))
        
    }
}

extension Event {
    static func loginUser(withUsername username: String, andPassword password: String) -> Observable<Event> {
        
        let operation = NetworkOperation.login(forUsername: username, andPassword: password)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<LogedUser> in
                return ParseTask<LogedUser>().execute(withInput: rawData)
            }
            .map { loggedUser -> String? in
                return loggedUser.token
            }
            .asObservable()
            .flatMap{ (token: String?) -> Observable<Event> in
                
                guard let token = token else {
                    return Observable.just(Event.JwtTokenError(error: AAError.ParseError))
                }
                
                return Observable.just(Event.GotJwtToken(token: token))
            }
            .catchError { error -> Observable<Event> in
                return Observable.just(Event.JwtTokenError(error: AAError.LoginFailed))
        }
    }
}

extension Event {
    static func loadUser(withJwtToken jwtToken: String) -> Observable<Event> {
        
        let operation = NetworkOperation.getProfile(forJWTToken: jwtToken)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<UserProfile> in
                return ParseTask<UserProfile>().execute(withInput: rawData)
            }
            .asObservable()
            .flatMap { (profile: UserProfile) -> Observable<Event> in
                return Observable.just(Event.GotUserProfile(profile: profile))
            }
            .catchError { error -> Observable<Event> in
                return Observable.just(Event.UserProfileError)
        }
    }
}
