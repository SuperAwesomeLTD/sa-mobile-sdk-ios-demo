//
//  AllCompanies.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import Foundation
import ObjectMapper

class NetworkData <T: Mappable> : Mappable {

    var count: Int?
    var data: [T] = []
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        count <- map["count"]
        data <- map["data"]
    }
}
