//
//  CompaniesViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 03/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class CompaniesViewModel {

    var viewModels: [CompanyViewModel] = []
    var data: [Company] = [] {
        didSet {
            viewModels = []
            for i in 0..<data.count {
                viewModels.append(CompanyViewModel(withCompany: data[i], atIndex: i))
            }
        }
    }
}
