//
//  Events.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import SuperAwesome

enum Event {
    // jwt token + login
    case LoadingJwtToken
    case NoJwtToken
    case JwtTokenError
    case EditLoginDetails
    case GotJwtToken(token: String)
    // profile
    case GotUserProfile(profile: UserProfile)
    case UserProfileError
    // apps & placements
    case GotAppsForCompany(apps: [App])
    case FilterApps(withSearchTerm: String?)
    case SelectPlacement(placementId: Int?)
    // companies
    case LoadingCompanies
    case GotCompanies(comps: [Company])
    case FilterCompanies(withSearchTerm: String?)
    case SelectCompany(company: Company)
    // creatives
    case GotCreatives(creatives: [SACreative])
    case FilterCreatives(withSearchTerm: String?)
    case SelectCreative(creative: SACreative)
    // selected ad & response for settings
    case GotResponse(response: SAResponse?, format: AdFormat)
}

extension Event {
    static func checkIsUserLoggedIn () -> Observable<Event> {
        
        if let jwtToken = UserDefaults.standard.string(forKey: "jwtToken"),
           let metadata = UserMetadata.processMetadata(jwtToken: jwtToken),
           metadata.isValid {
            return Observable.just(Event.GotJwtToken(token: jwtToken))
        }
        else {
            return Observable.just(Event.NoJwtToken)
        }
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
    static func loadCreatives (forPlacementId placementId: Int, andJwtToken token: String) -> Observable<Event> {
        
        let request = LoadCreativesRequest(placementId: placementId, token: token)
        let task = LoadCreativesTask()
        
        return task.execute(withInput: request)
            .toArray()
            .asObservable()
            .map({ (creatives: [SACreative]) -> Event in
                return Event.GotCreatives(creatives: creatives)
            })
            .catchError { error -> Observable<Event> in
                return Observable.just(Event.GotCreatives(creatives: []))
            }
    }
}

extension Event {
    static func loadAdResponse (forCreative creative: SACreative?) -> Observable<Event> {
        
        // return error if not a valid creative somehow
        guard let creative = creative else {
            return Observable.just(Event.GotResponse(response: nil, format: AdFormat.unknown))
        }
        
        // form the ad
        let ad = SAAd ()
        ad.lineItemId = 10000;
        ad.creative = creative
        if ad.creative.format == .tag && ad.creative.details.format.contains("video") {
            ad.creative.format = .video
            ad.creative.details.vast = ad.creative.details.tag
        }

        let request = ProcessAdRequest(ad: ad)
        let task = ProcessAdTask()
        
        return task.execute(withInput: request)
            .flatMap { (response: SAResponse) -> Single<Event> in
                let format = AdFormat.fromResponse(response)
                return Single.just(Event.GotResponse(response: response, format: format))
            }
            .catchError { error -> Single<Event> in
                return Single.just(Event.GotResponse(response: nil, format: AdFormat.unknown))
            }
            .asObservable()
    }
}

