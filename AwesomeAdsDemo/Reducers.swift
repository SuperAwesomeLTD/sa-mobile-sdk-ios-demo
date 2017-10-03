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
                    profileState: profileReducer(previous.profileState, event: event))
}

func loginReducer (_ previous: LoginState, event: Event) -> LoginState {
    var state = previous
    state.isLoading = false
    state.error = nil
    
    switch event {
    case .LoadingJwtToken:
        state.isLoading = true
        break
    case .NoJwtToken:
        // do nothing
        break
    case .JwtTokenError(let error):
        state.error = error
        break
    case .GotJwtToken(let token):
        state.jwtToken = token
        break
    default:
        break
    }
    
    return state
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
