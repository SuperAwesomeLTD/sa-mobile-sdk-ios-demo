//
//  SABaseViewController+Store.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 03/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension SABaseViewController {

    private var currentState: AppState {
        return store.current
    }
    
    var jwtToken: String {
        let loginState = currentState.loginState
        let token = loginState.jwtToken ?? ""
        return token
    }
    
    var profile: UserProfile? {
        let profileState = currentState.profileState
        let profile = profileState?.profile
        return profile
    }
    
    var companyId: Int {
        return currentState.selectedCompany ?? currentState.profileState?.profile.companyId ?? -1
    }
}
