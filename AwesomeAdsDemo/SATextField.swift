//
//  UITextField+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SATextField: UITextField {
    
    // public border value
    public var border: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set background color
        self.backgroundColor = UIColor.clear
        
        // set size
        let W = UIScreen.main.bounds.width - 40
        let H = 30
        
        // add a border
        border = UIView()
        border?.frame = CGRect(x: 0, y: H-1, width: Int(W), height: 1)
        border?.backgroundColor = UIColor.lightGray
        self.addSubview(border!)
    }
    
    func setRedOrGrayBorder (_ isValid: Bool) {
        border?.backgroundColor = isValid ? UIColor.lightGray : UIColor.red
    }
    
}
