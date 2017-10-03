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
        store?.dispatch(checkIsUserLoggedInAction())
    }
    
    override func handle(_ state: AppState) {
        performSegue(state.loginState.jwtToken != nil ? "IntroToLoad" : "IntroToLogin")
    }
}
