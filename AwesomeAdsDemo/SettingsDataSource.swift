//
//  SettingsDataSource.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class SettingsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [SettingViewModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingRow.Identifier, for: indexPath) as! SettingRow
        cell.viewModel = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do nothing
    }
}
