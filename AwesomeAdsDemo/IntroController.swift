//
//  IntroController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class IntroController: SABaseViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LoginManager.sharedInstance
            .check()
            .subscribe(onNext: { loggedUser in
                
                LoginManager.sharedInstance.setLoggedUser(user: loggedUser)
                self.performSegue("IntroToMain")
                
            }, onError: { (error) in
                self.performSegue("IntroToLogin")
            })
            .addDisposableTo(disposeBag)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
