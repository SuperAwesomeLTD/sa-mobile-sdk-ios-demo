//
//  AppViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class AppViewModel: MainViewModel {
    var app: App
    
    init(withApp app: App) {
        self.app = app
        
        super.init()
        
        if let name = app.name {
            super.searcheableText = name
        }
    }
}
