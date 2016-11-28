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
    
    // other vars
    let disposeBag = DisposeBag()
    private var currentModel: UserModel?
    private var placementId: Int = 0
    private var test: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSABigNavigationController()
        
        placementTextView.rx.text.orEmpty
            .map({ text -> UserModel in return UserModel(text) })
            .do(onNext: { userModel in self.currentModel = userModel })
            .map({ userModel -> Bool in return userModel.isValid() })
            .subscribe(onNext: { isValid in self.setNextButtonState(isValid) })
            .addDisposableTo(disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: { Void in
            
            if let current = self.currentModel {
                self.placementId = current.getPlacementID()
                self.test = false
                self.performSegue(withIdentifier: "UserToSettings", sender: self)
            }
            
        }).addDisposableTo(disposeBag)
        
        moreButton.rx.tap.subscribe(onNext: { Void in self.findOutMorePopup() } ).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNextButtonState (_ state: Bool) {
        nextButton.isEnabled = state
        nextButton.backgroundColor = state ? SAColor(red: 20, green: 124, blue: 205) : UIColor.lightGray
    }
    
    func findOutMorePopup () {
        SAPopup.sharedManager().show(withTitle: "Log in to AwesomeAds",
                                     andMessage: "Under the \'Apps and Sites\' section you\'ll see a \'Placement ID\' column next to each of your placements.",
                                     andOKTitle: "Got it!",
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .default,
                                     andPressed: nil)
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
