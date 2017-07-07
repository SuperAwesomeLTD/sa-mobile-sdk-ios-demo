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
        
        UserWorker.isUserLoggedIn()
            .flatMap { logedUser -> Single<UserProfile> in
                return UserWorker.getProfile(forToken: DataStore.shared.jwtToken!)
            }
            .subscribe(onSuccess: { profile in
                self.performSegue("IntroToMain")
            }, onError: { error in
                self.performSegue("IntroToLogin")
            })
            .addDisposableTo(disposeBag)
    }
}
