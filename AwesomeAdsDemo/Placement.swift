//
//  Placement.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import ObjectMapper

class Placement: Mappable {

    var id: Int?
    var name: String?
    var format: String?
    var width: Int?
    var height: Int?
    
    required public init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        format <- map["format"]
        width <- map["width"]
        height <- map["height"]
    }
}
