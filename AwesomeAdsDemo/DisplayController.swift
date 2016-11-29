//
//  DisplayController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class DisplayController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare view controller
        self.makeSASmallNavigationController(withTitle: "Display Ad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
