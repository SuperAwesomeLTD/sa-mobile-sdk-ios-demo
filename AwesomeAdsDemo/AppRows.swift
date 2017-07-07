//
//  AppRows.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 07/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class AppRow: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class PlacementRow: UITableViewCell {
    
    @IBOutlet weak var placementIcon: UIImageView!
    @IBOutlet weak var placementName: UILabel!
    @IBOutlet weak var placementID: UILabel!
    @IBOutlet weak var placementSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
