//
//  CompanyViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 03/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class CompanyViewModel {

    private var index: Int
    var company: Company
    
    init(withCompany company: Company, atIndex i: Int) {
        self.company = company
        self.index = i
    }
    
    var backgroundColor: UIColor {
        return index % 2 == 0 ?
            UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1) :
            UIColor.white
    }
    
    var companyName: String {
        return company.name ?? "N/A"
    }
    
    var companyId: Int? {
        return company.id
    }
}
