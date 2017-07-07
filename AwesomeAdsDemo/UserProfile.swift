//
//  UserProfile.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import ObjectMapper

class UserProfile: Mappable {

    var id: Int?
    var username: String?
    var email: String?
    var companyId: Int?
    var logedUser: LogedUser?
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        email <- map["email"]
        companyId <- map["companyId"]
    }
    
    public var isValid:  Bool {
        return logedUser?.isValid ?? false
    }
}
