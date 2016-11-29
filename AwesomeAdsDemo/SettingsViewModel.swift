//
//  SettingsViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SettingsViewModel: NSObject {

    // member vars
    private var item: String?
    private var details: String?
    private var value: Bool?
    private var active: Bool = false
    
    init(item: String, details: String, value: Bool) {
        super.init()
        self.item = item
        self.details = details
        self.value = value
    }
    
    func getItemTitle() -> String {
        if let item = item {
            return item
        } else {
            return "Item"
        }
    }
    
    func getItemDetails () -> String {
        if let details = details {
            return details
        } else {
            return "Details"
        }
    }
    
    func getItemValue () -> Bool {
        if let value = value {
            return value
        } else {
            return false
        }
    }
    
    func setValue (_ value: Bool) {
        self.value = value
    }
    
    func setActive (_ active: Bool) {
        self.active = active
    }
    
    func getActive () -> Bool {
        return active
    }
    
}
