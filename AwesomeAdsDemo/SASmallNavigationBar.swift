//
//  SASmallNavigationBar.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SASmallNavigationBar: UINavigationBar {

    public var closeBtn: UIButton?
    
    init(_ titleTxt: String) {
        let W = Int(UIScreen.main.bounds.size.width)
        let H = 70
        
        // call super
        super.init(frame: CGRect(x: 0, y: 0, width: W, height: H))
        
        // set the background
        self.backgroundColor = SAColor(red: 250, green: 250, blue: 250)
        
        // add the title
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 20, width: W, height: 50)
        title.text = titleTxt
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor.black
        self.addSubview(title)
        
        // add the close button
        closeBtn = UIButton()
        if let close = closeBtn {
            close.frame = CGRect(x: W - 44, y: 29, width: 32, height: 32)
            close.setImage(UIImage(named: "close"), for: .normal)
            self.addSubview(close)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
