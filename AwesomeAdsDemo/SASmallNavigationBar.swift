//
//  SASmallNavigationBar.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class SASmallNavigationBar: UINavigationBar {

    private var title: UILabel?
    public var closeBtn: UIButton?
    
    init() {
        let W = Int(UIScreen.main.bounds.size.width)
        let H = 70
        
        // call super
        super.init(frame: CGRect(x: 0, y: 0, width: W, height: H))
        
        // set the background
        self.isTranslucent = false
        self.barTintColor = UIColorFromHex(0xED1C23)
        
        // add the title
        title = UILabel()
        if let title = title {
            title.frame = CGRect(x: 0, y: 20, width: W, height: 50)
            title.textAlignment = .center
            title.font = UIFont.boldSystemFont(ofSize: 14)
            title.textColor = UIColor.white
            self.addSubview(title)
        }
        
        // add the close button
        closeBtn = UIButton()
        if let close = closeBtn {
            close.frame = CGRect(x: W - 44, y: 29, width: 32, height: 32)
            close.setImage(UIImage(named: "close"), for: .normal)
            self.addSubview(close)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init ()
    }
    
    public func setTitle (_ text: String) {
        if let title = title {
            title.text = text
        }
    }

}
