//
//  SANavigationBar.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class SABigNavigationBar: UINavigationBar {
    
    init() {
        let W = Int(UIScreen.main.bounds.size.width)
        let H = 100
        
        // call super
        super.init(frame: CGRect(x: 0, y: 0, width: W, height: H))
        
        // set the background
        self.backgroundColor = UIColorFromHex(0xFAFAFA)
        
        // create the Awesome Ads image
        let imgX = W/2 - 61
        let imgY = 50
        let image: UIImageView = UIImageView(image: UIImage(named: "AWESOMEADS"))
        image.frame = CGRect(x: imgX, y: imgY, width: 123, height: 19)
        self.addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
