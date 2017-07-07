//
//  DataStore.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class DataStore {

    static let shared = DataStore()
    
    private init () {}
    
    var jwtToken: String? {
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: "jwtToken")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "jwtToken")
        }
    }
    
    var company: Company?
    var profile: UserProfile?
    
}
