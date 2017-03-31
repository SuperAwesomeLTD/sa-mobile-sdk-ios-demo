//
//  UserHistoryViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class UserHistoryViewModel: NSObject {

    private var placementId: Int = 0
    private var placementString: String!
    private var dateStr: String!
    private var timestamp: TimeInterval = 0
    
    init(history: UserHistory) {
        super.init()
        self.placementId = history.getPlacementId()
        self.placementString = "\(self.placementId)"
        self.timestamp = history.getTimestamp()
        
        let date = Date(timeIntervalSince1970: history.getTimestamp())
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = Locale.current
        formatter.dateFormat = "dd/MM/yyyy"
        dateStr = formatter.string(from: date)
    }
    
    func getPlacement () -> String {
        return placementString!
    }
    
    func getDate () -> String {
        return dateStr!
    }
    
    func getPlacementId () -> Int {
        return placementId
    }
    
    func getTimestamp () -> TimeInterval {
        return timestamp
    }
    
}
