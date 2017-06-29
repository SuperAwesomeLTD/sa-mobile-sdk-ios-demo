//
//  MainController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import QuartzCore

class MainController: SABaseViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var demoFormatsContainer: UIView!
    @IBOutlet weak var yourPlacementContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.125
    }
    
    @IBAction func indexChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            yourPlacementContainer.isHidden = false
            demoFormatsContainer.isHidden = true
            break
        case 1:
            yourPlacementContainer.isHidden = true
            demoFormatsContainer.isHidden = false
            break
        default:
            break; 
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
