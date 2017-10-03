//
//  State.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

struct AppState: State {
    var loginState: LoginState?
    var profileState: ProfileState?
    var appState = LoadedAppsState()
}

struct LoginState: State {
    var jwtToken: String?
    var isLoading: Bool = false
}

struct ProfileState: State {
    var profile: UserProfile
}

struct LoadedAppsState: State {
    private var fullApps: [App] = []
    var search: String?
    var error: AAError?
    var apps: [App] {
        
        var result: [App] = []
        
        fullApps.forEach { (app: App) in
            let placements = app.placements
                .filter{ (placement: Placement) -> Bool in
                    
                    guard let search = search, search != "" else {
                        return true
                    }
                    
                    let name = placement.name ?? ""
                    let id = placement.id ?? 0
                    let searchTerm = "\(name)_\(id)"
                    
                    return searchTerm.lowercased().contains(search.lowercased())
                }
            
            if placements.count > 0 {
                app.placements = placements
                result.append(app)
            }
        }
        
        return result
    }
    
    init(withFullData data: [App]) {
        self.fullApps = data
    }
    
    init () {
        // do nothing
    }
}
