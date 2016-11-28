//
//  UserModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    private var placementId: Int?
    private var placementString: String?
    
    init (_ placementString: String) {
        super.init()
        self.placementString = placementString
        if let str = self.placementString {
            placementId = Int(str)
        } else {
            placementId = 0
        }
    }

    func isValid () -> Bool {
        return placementId != nil
    }
    
    func getPlacementID () -> Int {
        if let pid = placementId {
            return pid
        } else {
            return 0
        }
    }
}
