//
//  Reducers.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

func appReducer (_ previous: AppState, event: Event) -> AppState {
    return AppState(loginState: loginReducer(previous.loginState, event: event),
                    profileState: profileReducer(previous.profileState, event: event),
                    appState: appsReducer(previous.appState, event: event))
}

func loginReducer (_ previous: LoginState?, event: Event) -> LoginState? {
    switch event {
    case .LoadingJwtToken:
        return LoginState(jwtToken: nil, isLoading: true)
    case .NoJwtToken, .JwtTokenError:
        return nil
    case .GotJwtToken(let token):
        return LoginState(jwtToken: token, isLoading: false)
    default:
        return previous
    }
}

func profileReducer (_ previous: ProfileState?, event: Event) -> ProfileState? {
    switch event {
    case .GotUserProfile(let profile):
        return ProfileState(profile: profile)
    case .UserProfileError:
        return previous
    default:
        return previous
    }
}

func appsReducer (_ previous: LoadedAppsState, event: Event) -> LoadedAppsState {
    var state = previous
    
    switch event {
    case .GotAppsForCompany(let apps):
        return LoadedAppsState(withFullData: apps)
    case .FilterApps(let search):
        state.search = search
        return state
    default:
        return state
    }
}
