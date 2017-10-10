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
    var loginState = LoginState()
    var profileState: UserProfile?
    var appState = LoadedAppsState()
    var companiesState = CompaniesState()
    var creativesState = CreativesState()
    var adState = AdState()
}

struct LoginState: State {
    var jwtToken: String?
    var isLoading: Bool = false
    var isEditing: Bool = false
    var loginError: Bool = false
}

struct LoadedAppsState: State {
    var apps: [App] = []
    var selectedPlacement: Int?
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
}

struct CompaniesState: State {
    var companies: [Company] = []
    var selectedCompany: Company?
    var isLoading: Bool = false 
    var search: String?
    var filtered: [Company] {
        return companies.filter { company -> Bool in
            return selectWith(searchTerm: search, searchItem: company.name)
        }
    }
}

struct CreativesState: State {
    var creatives: [SACreative] = []
    var search: String?
    var selectedCreative: SACreative?
    var filtered: [SACreative] {
        return creatives.filter { creative -> Bool in
            return selectWith(searchTerm: search, searchItem: creative.name)
        }
    }
}

struct AdState: State {
    var response: SAResponse?
    var format = AdFormat.unknown
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

