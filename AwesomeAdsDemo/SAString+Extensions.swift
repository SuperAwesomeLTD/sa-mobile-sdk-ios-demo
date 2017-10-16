//
//  SAString.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 13/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
