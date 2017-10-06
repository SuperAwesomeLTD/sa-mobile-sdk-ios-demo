//
//  State.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import SAModelSpace

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
    var filtered: [App] {
        
        var result: [App] = []
        
        apps.forEach { (app: App) in
            
            let placements = app.placements.filter { placement -> Bool in
                let name = placement.name ?? ""
                let id = placement.id ?? 0
                let item = "\(name)_\(id)"
                return selectWith(searchTerm: search, searchItem: item)
            }
            
            if placements.count > 0 {
                app.placements = placements
                result.append(app)
            }
        }
        
        return result
    }
    
    init(withFullData data: [App]) {
        self.apps = data
    }
    
    init () {
        // do nothing
    }
}

struct CompaniesState: State {
    fileprivate var companies: [Company] = []
    var search: String?
    var filtered: [Company] {
        return companies.filter { company -> Bool in
            return selectWith(searchTerm: search, searchItem: company.name)
        }
    }
    
    init(withFullData data: [Company]) {
        self.companies = data
    }
    
    init () {
        // do nothing
    }
}

struct CreativesState: State {
    fileprivate var creatives: [SACreative] = []
    var search: String?
    var filtered: [SACreative] {
        return creatives.filter { creative -> Bool in
            return selectWith(searchTerm: search, searchItem: creative.name)
        }
    }
    
    init(withFullData data: [SACreative]) {
        self.creatives = data
    }
    
    init() {
        // do nothing
    }
}

extension State {
    
    func selectWith(searchTerm: String?, searchItem: String?) -> Bool {
        guard let search = searchTerm, search != "" else {
            return true
        }
        
        if let item = searchItem {
            return item.lowercased().contains(search.lowercased())
        } else {
            return false
        }
    }
}

