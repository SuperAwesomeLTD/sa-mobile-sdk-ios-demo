//
//  AppViewModels.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 07/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class MainViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlacementRow.Identifier, for: indexPath) as! PlacementRow
        cell.viewModel = sections[indexPath.section].models[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
