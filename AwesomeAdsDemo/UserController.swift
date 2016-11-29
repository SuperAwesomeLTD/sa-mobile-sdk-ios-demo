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

class UserController: UIViewController {

    // outlets
    @IBOutlet weak var placementTextView: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    // the dispose abg
    let disposeBag = DisposeBag()
    
    // other vars
    private var currentModel: UserModel!
    private var placementId: Int = 0
    private var test: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSABigNavigationController()
        
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
                self.nextButton.backgroundColor = isValid ? SAColor(red: 20, green: 124, blue: 205) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // next button tap
        nextButton.rx.tap
            .subscribe(onNext: { Void in
            
                self.placementId = self.currentModel.getPlacementID()
                self.test = false
                self.performSegue(withIdentifier: "UserToSettings", sender: self)
            
            }).addDisposableTo(disposeBag)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let dest = nav.viewControllers.first as? SettingsController
        {
            dest.placementId = self.placementId
            dest.test = self.test
        }
    }
}
