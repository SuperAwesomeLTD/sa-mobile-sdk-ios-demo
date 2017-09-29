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
        store?.addListener(self)
        store?.dispatch(checkIsUserLoggedInAction)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store?.removeListener(self)
    }
}

extension IntroController: HandlesStateUpdates {
    func handle(_ state: AppState) {
        
        if state.loginState.jwtToken != nil {
            self.performSegue("IntroToMain")
        }
        else {
            self.performSegue("IntroToLogin")
        }
    }
}
