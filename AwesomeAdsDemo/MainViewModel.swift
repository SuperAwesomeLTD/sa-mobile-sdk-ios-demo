//
//  AppViewModels.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 07/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    
    struct Section {
        var title: String
        var models: [PlacementViewModel] = []
    }
    
    var sections: [Section] = []
    
    var data: [App] = [] {
        didSet {
            sections = data.map { (app: App) -> Section in
                let title = app.name ?? "N/A"
                let models = app.placements.map { (placement: Placement) -> PlacementViewModel in
                    return PlacementViewModel(withPlacement: placement)
                }
                return Section(title: title, models: models)
            }
        }
    }
}
