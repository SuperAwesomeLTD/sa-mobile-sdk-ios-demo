//
//  LoadController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 03/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import SAUtils

class LoadController: SABaseViewController {

    private var jwtToken: String {
        let currentState = store?.getCurrentState()
        let loginState = currentState?.loginState
        let token = loginState?.jwtToken ?? ""
        return token
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store?.dispatch(Event.loadUser(withJwtToken: jwtToken))
    }
    
    fileprivate func authError () {
        SAAlert.getInstance().show(withTitle: "page_load_popup_error_title".localized,
                                   andMessage: "page_load_popup_error_message".localized,
                                   andOKTitle: "page_load_popup_error_try_again".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default) { (btn, val) in
                                        self.store?.dispatch(Event.loadUser(withJwtToken: self.jwtToken))
                                   }
    }
    
    override func handle(_ state: AppState) {
        
        guard state.profileState != nil else {
            authError()
            return
        }
        
        performSegue("LoadToMain")
    }
}
