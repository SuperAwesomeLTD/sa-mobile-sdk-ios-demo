//
//  SettingsController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    var placementId: Int = 0
    var test: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSASmallNavigationController("Settings")
        print("PID \(placementId) - \(test)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
