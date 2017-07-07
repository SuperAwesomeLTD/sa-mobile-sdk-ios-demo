//
//  Company.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import ObjectMapper

class Company: Mappable {

    var data: [App] = []
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        data <- map["data"]
    }
}
