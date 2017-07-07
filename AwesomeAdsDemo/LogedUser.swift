//
//  LogedUser.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import ObjectMapper

class LogedUser: Mappable {

    var token: String?
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        token <- map["token"]
    }
    
    public var isValid: Bool {
        return token != nil
    }
}
