//
//  UserController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SAUtils
import SuperAwesome

class UserController: SABaseViewController {

    // outlets
    @IBOutlet weak var placementTextView: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    // other vars
    private var currentModel: UserModel!
    
    // touch
    private var touch: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreButton.setTitle("page_user_button_more_title".localized, for: .normal)
        nextButton.setTitle("page_user_button_next_title".localized, for: .normal)
        placementTextView.placeholder = "page_user_textfield_placement_placeholder".localized
        
        // placement text view
        placementTextView.rx.text.orEmpty
            .map({ text -> UserModel in
                return UserModel(text)
            })
            .do(onNext: { userModel in
                self.currentModel = userModel
            })
            .map({ userModel -> Bool in
                return userModel.isValid()
            })
            .subscribe(onNext: { isValid in
                self.nextButton.isEnabled = isValid
                self.nextButton.backgroundColor = isValid ? UIColorFromHex(0x147CCD) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // next button tap
        nextButton.rx.tap
            .subscribe (onNext: { (Void) in
                
                self.performSegue(withIdentifier: "UserToCreatives", sender: self) { (segue, sender) in
                    
                    if let dest = segue.destination as? CreativesController {
                        dest.placementId = self.currentModel.getPlacementID()
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        // more button tap
        moreButton.rx.tap
            .subscribe(onNext: { Void in
            
                SAAlert.getInstance().show(withTitle: "page_user_popup_more_title".localized,
                                           andMessage: "page_user_popup_more_message".localized,
                                           andOKTitle: "page_user_popup_more_ok_button".localized,
                                           andNOKTitle: nil,
                                           andTextField: false,
                                           andKeyboardTyle: .default,
                                           andPressed: nil)
            
            }).addDisposableTo(disposeBag)
        
        // the touch gesture recogniser
        touch = UITapGestureRecognizer ()
        touch?.rx.event.asObservable()
            .subscribe(onNext: { (event) in
                self.placementTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        self.view.addGestureRecognizer(touch!)
    }
}
