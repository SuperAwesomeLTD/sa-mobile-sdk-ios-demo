//
//  App.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import ObjectMapper

class App: Mappable {
    
    var id: Int?
    var name: String?
    var placements: [Placement] = []
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        placements <- map["placements"]
    }
}
