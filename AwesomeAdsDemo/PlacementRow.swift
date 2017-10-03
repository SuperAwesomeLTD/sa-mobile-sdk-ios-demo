//
//  PlacementRow.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class PlacementRow: UITableViewCell {
    
    static let Identifier = "PlacementRowID"
    
    @IBOutlet weak var placementIcon: UIImageView!
    @IBOutlet weak var placementName: UILabel!
    @IBOutlet weak var placementID: UILabel!
    @IBOutlet weak var placementSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: PlacementViewModel! {
        didSet {
            self.placementName.text = viewModel.placementName
            self.placementID.text = viewModel.placementId
            self.placementSize.text = viewModel.placementSize
            self.placementIcon.image = viewModel.placementIcon
        }
    }
}
