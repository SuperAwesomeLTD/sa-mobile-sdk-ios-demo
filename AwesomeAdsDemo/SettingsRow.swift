//
//  SettingsRow.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SettingsRow: UITableViewCell {

    static let Identifier = "SettingsRowID"
    
    @IBOutlet weak var settingsItem: UILabel!
    @IBOutlet weak var settingsDescription: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
