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

class SATextField: UITextField, UITextFieldDelegate {
    
    // public border value
    public var border: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        
        // set background color
        self.backgroundColor = UIColor.clear
        
        // set size
        let W = UIScreen.main.bounds.width - 40
        let H = 30
        
        // add a border
        border = UIView()
        border?.frame = CGRect(x: 0, y: H-2, width: Int(W), height: 2)
        setGrayBorder()
        self.addSubview(border!)
    }
    
    private func setGrayBorder () {
        border?.backgroundColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    private func setGreenBorder () {
        border?.backgroundColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setGreenBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setGrayBorder()
    }
    
}
