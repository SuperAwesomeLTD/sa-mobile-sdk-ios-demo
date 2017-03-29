//
//  UserHistoryRow.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class UserHistoryRow: UITableViewCell {

    @IBOutlet weak var placement: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
