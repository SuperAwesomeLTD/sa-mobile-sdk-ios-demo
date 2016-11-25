//
//  DemoFormatsRow.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class DemoFormatsViewModel: NSObject {

    private var placementId: Int = 0
    private var imageSource: String
    private var formatName: String
    private var formatDetails: String
    
    init (placementId: Int, image: String, name: String, details: String) {
        self.placementId = placementId
        self.imageSource = image
        self.formatName = name
        self.formatDetails = details
        super.init()
    }
    
    func getPlacementId () -> Int {
        return placementId
    }
    
    func getSource () -> String {
        return imageSource
    }
    
    func getName () -> String {
        return formatName
    }
    
    func getDetails () -> String {
        return formatDetails
    } 
}
