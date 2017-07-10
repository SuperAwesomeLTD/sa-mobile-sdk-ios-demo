//
//  Permission.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import Foundation
import ObjectMapper

class Permission: Mappable {

    var id: Int?
    var name: String?
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
