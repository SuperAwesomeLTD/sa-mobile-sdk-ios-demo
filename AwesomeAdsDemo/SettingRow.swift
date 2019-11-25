//
//  SettingsRow.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SettingRow: UITableViewCell {

    static let Identifier = "SettingRowID"
    
    @IBOutlet weak var settingsItem: UILabel!
    @IBOutlet weak var settingsDescription: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    var viewModel: SettingViewModel! {
        didSet {
            backgroundColor = viewModel.getIndex() % 2 == 0 ? UIColor.white : UIColor(rgb: 0xf7f7f7)
            settingsItem.text = viewModel.getItemTitle()
            settingsDescription.text = viewModel.getItemDetails()
            settingsSwitch.isOn = viewModel.getItemValue()
            settingsSwitch.addTarget(self, action: #selector(toggle), for: UIControl.Event.valueChanged)
        }
    }
    
    @objc private func toggle () {
        viewModel.setValue(settingsSwitch.isOn)
    }
}
