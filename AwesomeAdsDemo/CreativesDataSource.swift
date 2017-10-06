//
//  CreativesDataSource.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import SAModelSpace

protocol CreativesDataSourceDelegate {
    func didSelect(placementId id: Int?, andCreative: SACreative)
}

class CreativesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var selectedPlacementId: Int?
    var data: [CreativeViewModel] = []
    var delegate: CreativesDataSourceDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreativeRow.Identifier, for: indexPath) as! CreativeRow
        cell.viewModel = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.row].getCreative()
        delegate?.didSelect(placementId: selectedPlacementId, andCreative: model)
    }
}
