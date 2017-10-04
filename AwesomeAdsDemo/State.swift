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
    var companiesState = CompaniesState()
    var selectedCompany: Int?
    var selectedPlacement: Int?
}

struct LoginState: State {
    var jwtToken: String?
    var isLoading: Bool = false
}

struct ProfileState: State {
    var profile: UserProfile
}

struct LoadedAppsState: State {
    fileprivate var apps: [App] = []
    var search: String?
    var error: AAError?
    
    init(withFullData data: [App]) {
        self.apps = data
    }
    
    init () {
        // do nothing
    }
}

extension LoadedAppsState {
    var filtered: [App] {
        
        var result: [App] = []
        
        apps.forEach { (app: App) in
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
}

struct CompaniesState: State {
    fileprivate var companies: [Company] = []
    var search: String?
    
    init(withFullData data: [Company]) {
        self.companies = data
    }
    
    init () {
        // do nothing
    }
}

extension CompaniesState {
    var filtered: [Company] {
        
        guard let search = search, search != "" else {
            return companies
        }
        
        return companies.filter { (company: Company) -> Bool in
            return company.name!.lowercased().contains(search.lowercased())
        }
    }
}
