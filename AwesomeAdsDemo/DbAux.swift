//
//  DbAux.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class DbAux: NSObject {
    
    static func savePlacementToHistory (history: UserHistory) {
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: history)
        defaults.setValue(data, forKey: "phistory_\(history.getPlacementId())")
        defaults.synchronize()
    }
    
    static func getPlacementsFromHistory () -> [UserHistory] {
        
        var histories:[UserHistory] = []
        
        let defaults = UserDefaults.standard
        let keys = defaults.dictionaryRepresentation().keys
        
        for key in keys {
            if key.contains("phistory_") {
                let decoded = defaults.object(forKey: key) as! Data
                let history = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserHistory
                histories.append(history)
            }
        }
        
        return histories
        
    }
    

}
