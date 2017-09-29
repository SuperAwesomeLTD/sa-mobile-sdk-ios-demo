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
    
    if event is GetJwtTokenEvent {
        state.isLoading = true
    }
    if event is NoJwtTokenFoundEvent {
        // do nothing
    }
    else if let event = event as? ErrorTryingGetJwtTokenEvent {
        state.error = event.error
    }
    else if let event = event as? JwtTokenFoundEvent {
        state.jwtToken = event.jwtToken
    }
    
    return state
}

func profileReducer (_ previous: ProfileState, event: Event) -> ProfileState {
    let state = previous
    return state
}
