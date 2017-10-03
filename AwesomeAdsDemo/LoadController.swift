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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = getCurrentJwtToken()
        self.tryToLoadUser(forJwtToken: token)
    }
    
    private func getCurrentJwtToken() -> String {
        let currentState = store?.getCurrentState()
        let loginState = currentState?.loginState
        let token = loginState?.jwtToken ?? ""
        return token
    }
    
    private func tryToLoadUser (forJwtToken token: String) {
        store?.dispatch(loadUserAction(withJwtToken: token))
    }
    
    private func handleErrorClick () {
        let token = self.getCurrentJwtToken()
        self.tryToLoadUser(forJwtToken: token)
    }
    
    fileprivate func authError () {
        SAAlert.getInstance().show(withTitle: "page_load_popup_error_title".localized,
                                   andMessage: "page_load_popup_error_message".localized,
                                   andOKTitle: "page_load_popup_error_try_again".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default) { (btn, val) in
                                        self.handleErrorClick()
                                   }
    }
    
    override func handle(_ state: AppState) {
        
        if state.profileState.profile != nil {
            performSegue("LoadToMain")
        }
        
        if state.profileState.error != nil {
            authError()
        }
    }
}
