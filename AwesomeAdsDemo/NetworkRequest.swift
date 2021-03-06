//
//  NetworkRequest.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

public enum NetworkOperation {
    case login(forUsername: String, andPassword: String)
    case getProfile(forJWTToken: String)
    case getApps(forCompany: Int, andJWTToken: String)
    case getCompanies(forJWTToken: String)
    case getCompany(forId: Int, andJWTToken: String)
}

public enum NetworkMethod {
    case GET
    case POST
}

class NetworkRequest: Request {

    var operation: NetworkOperation
    
    init(withOperation operation: NetworkOperation) {
        self.operation = operation
    }
    
    var method: NetworkMethod {
        switch operation {
        case .login(_, _):
            return .POST
        case .getProfile(_):
            return .GET
        case .getApps(_, _):
            return .GET
        case .getCompanies(_):
            return .GET
        case .getCompany(_, _):
            return .GET
        }
    }
    
    var endpoint: String {
        switch operation {
        case .login(_, _):
            return "https://api.dashboard.superawesome.tv/v2/user/login"
        case .getProfile(_):
            return "https://api.dashboard.superawesome.tv/v2/user/me"
        case .getApps(let company, _):
            return "https://api.dashboard.superawesome.tv/v2/companies/\(company)/apps"
        case .getCompanies(_):
            return "https://api.dashboard.superawesome.tv/v2/companies"
        case .getCompany(let id, _):
            return "https://api.dashboard.superawesome.tv/v2/companies/\(id)"
        }
    }
    
    var query: [String: String] {
        switch operation {
        case .getApps(_, _):
            return [
                "include" : "placement",
                "sort" : "name",
                "all": "true"
            ]
        case .getCompanies(_):
            return [
                "sort" : "name",
                "all": "true"
            ]
        case .getProfile(_):
            return [
                "include" : "permission"
            ]
        default:
            return [:]
        }
    }
    
    var headers: [String:String] {
        switch operation {
        case .login(_, _):
            return [
                "Content-Type" : "application/json"
            ]
        case .getProfile(let jwtToken):
            return [
                "aa-user-token": jwtToken
            ]
        case .getApps(_, let jwtToken):
            return [
                "aa-user-token": jwtToken
            ]
        case .getCompanies(let jwtToken):
            return [
                "aa-user-token": jwtToken
            ]
        case .getCompany(_, let jwtToken):
            return [
                "aa-user-token": jwtToken
            ]
        }
    }
    
    var body: [String: String] {
        switch operation {
        case .login(let username, let password):
            return [
                "username" : username,
                "password" : password
            ]
        default:
            return [:]
        }
    }
    
    var error : Error {
        return AAError.NoInternet
    }
}
