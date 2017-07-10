//
//  ProfileViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {

    var fieldName: String
    var fieldValue: String
    var isActive: Bool = false
    
    init(withFieldName name: String, andFieldValue value: String, andActive isActive: Bool) {
        self.fieldName = name
        self.fieldValue = value
        self.isActive = isActive
        super.init()
    }
    
}
