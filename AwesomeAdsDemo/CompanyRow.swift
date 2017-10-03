//
//  CompanyRow.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class CompanyRow: UITableViewCell {

    static let Identifier = "CompanyRowID"
    
    @IBOutlet weak var companyName: UILabel!
    
    var viewModel: CompanyViewModel! {
        didSet {
            companyName.text = viewModel.companyName
            backgroundColor = viewModel.backgroundColor
        }
    }
}
