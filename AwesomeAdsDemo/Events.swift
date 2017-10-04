//
//  Events.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import SAAdLoader
import SAModelSpace

enum Event {
    // jwt token + login
    case LoadingJwtToken
    case NoJwtToken
    case JwtTokenError
    case GotJwtToken(token: String)
    // profile
    case GotUserProfile(profile: UserProfile)
    case UserProfileError
    // apps
    case GotAppsForCompany(apps: [App])
    case FilterApps(withSearchTerm: String?)
    // companies
    case GotCompanies(comps: [Company])
    case FilterCompanies(withSearchTerm: String?)
    // select company
    case SelectCompany(companyId: Int?)
    // select placement
    case SelectPlacement(placementId: Int?)
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
    static func loginUser (withUsername username: String, andPassword password: String) -> Observable<Event> {
        
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
            .do(onNext: { token in
                if let token = token {
                    UserDefaults.standard.set(token, forKey: "jwtToken")
                    UserDefaults.standard.synchronize()
                }
            })
            .flatMap{ (token: String?) -> Observable<Event> in
                
                guard let token = token else {
                    return Observable.just(Event.JwtTokenError)
                }
                
                return Observable.just(Event.GotJwtToken(token: token))
            }
            .catchError { error -> Observable<Event> in
                return Observable.just(Event.JwtTokenError)
            }
    }
}

extension Event {
    static func loadUser (withJwtToken jwtToken: String) -> Observable<Event> {
        
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

extension Event {
    static func loadApps (forCompany company: Int, andJwtToken token: String) -> Observable<Event> {
        
        let operation = NetworkOperation.getApps(forCompany: company, andJWTToken: token)
        let request = NetworkRequest(withOperation: operation)
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { rawData -> Single<NetworkData<App>> in
                return ParseTask<NetworkData<App>>().execute(withInput: rawData)
            }
            .asObservable()
            .flatMap { (data: NetworkData<App>) -> Observable<Event> in
                return Observable.just(Event.GotAppsForCompany(apps: data.data))
            }
            .catchError { error -> Observable<Event> in
                return Observable.just(Event.UserProfileError)
            }
    }
}

extension Event {
    static func loadCompanies (forJwtToken token: String) -> Observable<Event> {
        
        let operation = NetworkOperation.getCompanies(forJWTToken: token)
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
            .asObservable()
            .flatMap { (companies: [Company]) -> Observable<Event> in
                return Observable.just(Event.GotCompanies(comps: companies))
            }
            .catchError { error -> Observable<Event> in
                return Observable.just(Event.UserProfileError)
            }
    }
}

extension Event {
    static func loadCreatives (forPlacementId placementId: Int) -> Observable<Event> {
        
        SALoader.loadCreatives(placementId: placementId)
            .toArray()
            .flatMap { (creatives: [SACreative]) -> Observable<Event> in
                
            }
            .catchError { error -> Observable<Event> in
                
            }
    }
}
