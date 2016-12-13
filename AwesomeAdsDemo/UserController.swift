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
        
        moreButton.setTitle("user_controller_more_button_title".localized, for: .normal)
        nextButton.setTitle("user_controller_next_button_title".localized, for: .normal)
        placementTextView.placeholder = "user_controller_textfield_placeholder".localized
        
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
                self.performSegue(withIdentifier: "UserToSettings", sender: self)
            })
            .addDisposableTo(disposeBag)
        
        // more button tap
        moreButton.rx.tap
            .subscribe(onNext: { Void in
            
                SAPopup.sharedManager().show(withTitle: "user_controller_more_popup_title".localized,
                                             andMessage: "user_controller_more_popup_message".localized,
                                             andOKTitle: "user_controller_more_popup_ok_button".localized,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "user_controller_title".localized
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? SettingsController {
            destination.placementId = self.currentModel.getPlacementID()
            destination.test = false
        }
    }
}
