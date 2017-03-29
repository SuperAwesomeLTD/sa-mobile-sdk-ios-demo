//
//  UserHistory.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class UserHistory: NSObject, NSCoding {

    private var placementId: Int = 0;
    private var timestamp: TimeInterval = 0.0
    
    init (placementId: Int) {
        super.init()
        self.placementId = placementId
        self.timestamp = NSDate().timeIntervalSince1970
    }
    
    required init?(coder aDecoder: NSCoder) {
        placementId = aDecoder.decodeInteger(forKey: "placementId")
        timestamp = aDecoder.decodeDouble(forKey: "timestamp")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(placementId, forKey: "placementId")
        aCoder.encode(timestamp, forKey: "timestamp")
    }
    
    func getPlacementId () -> Int {
        return placementId
    }
    
    func getTimestamp () -> TimeInterval {
        return timestamp
    }
}
