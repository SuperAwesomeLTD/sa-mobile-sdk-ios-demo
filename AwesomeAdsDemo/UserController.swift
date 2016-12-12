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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        nextButton.rx.tap.subscribe (onNext: { (Void) in
            self.performSegue(withIdentifier: "UserToSettings", sender: self)
        })
        .addDisposableTo(disposeBag)
        
        // more button tap
        moreButton.rx.tap
            .subscribe(onNext: { Void in
            
                SAPopup.sharedManager().show(withTitle: "Log in to AwesomeAds",
                                             andMessage: "Under the \'Apps and Sites\' section you\'ll see a \'Placement ID\' column next to each of your placements.",
                                             andOKTitle: "Got it!",
                                             andNOKTitle: nil,
                                             andTextField: false,
                                             andKeyboardTyle: .default,
                                         	 andPressed: nil)
            
            }).addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? SettingsController {
            destination.placementId = self.currentModel.getPlacementID()
            destination.test = false

        }
    }
}
