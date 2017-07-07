//
//  UserMetadata.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import ObjectMapper

class UserMetadata: Mappable {

    var id: Int = 0
    var username: String?
    var email: String?
    var iat: Int = 0
    var exp: Int = 0
    var iss: String?
 
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        email <- map["email"]
        iat <- map["iat"]
        exp <- map["exp"]
        iss <- map["iss"]
    }
    
    var isValid : Bool {
        let now = NSDate().timeIntervalSince1970
        return (now - TimeInterval(exp)) < 0
    }
}

extension UserMetadata {
    
    static func processMetadata (jwtToken: String?) -> UserMetadata? {
        
        guard let jwtToken = jwtToken else {
            return nil
        }
        
        let subtokens: [String] = jwtToken.components(separatedBy: ".")
        
        if subtokens.count >= 2 {
            let token0 = subtokens[1]
            let token1 = token0 + "="
            let token2 = token1 + "="
            
            let data0 = Data(base64Encoded: token0, options: .ignoreUnknownCharacters)
            let data1 = Data(base64Encoded: token1, options: .ignoreUnknownCharacters)
            let data2 = Data(base64Encoded: token2, options: .ignoreUnknownCharacters)
            
            if let d0 = data0, let s0 = String(data: d0, encoding: .utf8) {
                return UserMetadata (JSONString: s0)
            }
            else if let d1 = data1, let s1 = String(data: d1, encoding: .utf8) {
                return UserMetadata (JSONString: s1)
            }
            else if let d2 = data2, let s2 = String(data: d2, encoding: .utf8) {
                return UserMetadata (JSONString: s2)
            }
            else {
                return nil
            }
        } else {
            return nil
        }
    }
}
