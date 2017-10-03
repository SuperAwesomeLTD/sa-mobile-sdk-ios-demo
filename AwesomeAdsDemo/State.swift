//
//  State.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

struct AppState: State {
    var loginState = LoginState()
    var profileState = ProfileState()
}

struct LoginState: State {
    var jwtToken: String?
    var isLoading: Bool = false
    var error: AAError?
}

struct ProfileState: State {
    var profile: UserProfile?
    var error: AAError?
}
