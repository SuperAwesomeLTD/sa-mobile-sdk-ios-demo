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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginManager.sharedInstance
            .check()
            .subscribe(onNext: { (loggedUser) in
                
                LoginManager.sharedInstance.setLoggedUser(user: loggedUser)
                self.performSegue(withIdentifier: "IntroToTabBar", sender: self)
                
            }, onError: { (error) in
                self.performSegue(withIdentifier: "IntroToLogin", sender: self)
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
