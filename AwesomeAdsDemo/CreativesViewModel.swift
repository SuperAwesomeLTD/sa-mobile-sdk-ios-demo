//
//  CreativesViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 06/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import SAModelSpace

class CreativesViewModel {

    var viewModels: [CreativeViewModel] = []
    var data: [SACreative] = [] {
        didSet {
            viewModels = []
            for i in 0..<data.count {
                viewModels.append(CreativeViewModel(withCreative: data[i], atIndex: i))
            }
        }
    }
}
