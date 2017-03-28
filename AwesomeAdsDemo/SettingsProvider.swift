//
//  SettingsProvider.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 28/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SuperAwesome

class SettingsProvider: NSObject {

    // constants
    private let KEY_PARENTAL_GATE = 1
    private let KEY_TRANSPARENT_BG = 2
    private let KEY_LOCK_PORTRAIT = 3
    private let KEY_LOCK_LANSCAPE = 4
    private let KEY_CLOSE_BUTTON = 5
    private let KEY_AUTO_CLOSE = 6
    private let KEY_SMALL_CLICK = 7
    
    // a reference to a settings dict
    private var settingsDict: [Int : SettingsViewModel] = [:]
    
    override init() {
        // call to super
        super.init()
        
        // fill settings dict with data
        self.settingsDict = [
            KEY_PARENTAL_GATE   : SettingsViewModel(item: "page_settings_row_pg_gate_title".localized,
                                                    details: "page_settings_row_pg_gate_details".localized,
                                                    value: true),
            KEY_TRANSPARENT_BG  : SettingsViewModel(item: "page_settings_row_bg_color_title".localized,
                                                    details: "page_settings_row_bg_color_details".localized,
                                                    value: false),
            KEY_LOCK_PORTRAIT   : SettingsViewModel(item: "page_settings_row_lock_portrait_title".localized,
                                                    details: "page_settings_row_lock_portrait_details".localized,
                                                    value: false),
            KEY_LOCK_LANSCAPE   : SettingsViewModel(item: "page_settings_row_lock_landscape_title".localized,
                                                    details: "page_settings_row_lock_landscape_details".localized,
                                                    value: false),
            KEY_CLOSE_BUTTON    : SettingsViewModel(item: "page_settings_row_close_button_title".localized,
                                                    details: "page_settings_row_close_button_details".localized,
                                                    value: false),
            KEY_AUTO_CLOSE      : SettingsViewModel(item: "page_settings_row_auto_close_title".localized,
                                                    details: "page_settings_row_auto_close_details".localized,
                                                    value: true),
            KEY_SMALL_CLICK     : SettingsViewModel(item: "page_settings_row_small_click_title".localized,
                                                    details: "page_settings_row_small_click_details".localized,
                                                    value: false),
        ]
    }
    
    func getSettings(forAdFormat adFormat: AdFormat) -> Observable<SettingsViewModel> {
        return Observable.create({ (observer) -> Disposable in
            
            // customise options
            self.getParentalGate().setActive(true)
            
            switch (adFormat) {
            case .unknown:
                self.getParentalGate().setActive(false)
                break
            case .smallbanner, .normalbanner, .bigbanner,  .mpu:
                self.getTransparentBg().setActive(true)
                break
            case .mobile_portrait_interstitial,
                 .mobile_landscape_interstitial,
                 .tablet_portrait_interstitial,
                 .tablet_landscape_interstitial:
                self.getLockToPortrait().setActive(true)
                self.getLockToLandscape().setActive(true)
                break
            case .video:
                self.getLockToPortrait().setActive(true)
                self.getLockToLandscape().setActive(true)
                self.getCloseButton().setActive(true)
                self.getAutoClose().setActive(true)
                self.getSmallClick().setActive(true)
                break
            case .gamewall: break
            }
            
            // create an array of settings to use for observer
            var settings: [SettingsViewModel] = []
            
            for i in 1...7 {
                if let setting = self.settingsDict[i] as SettingsViewModel! {
                    settings.append(setting)
                }
            }
            
            // call observer methods
            for setting in settings {
                observer.onNext(setting)
            }
            observer.onCompleted()
            
            // return the disposable
            return Disposables.create ()
        })
    }
    
    func getParentalGate () -> SettingsViewModel {
        return settingsDict[KEY_PARENTAL_GATE]!
    }
    
    func getTransparentBg () -> SettingsViewModel {
        return settingsDict[KEY_TRANSPARENT_BG]!
    }
    
    func getLockToPortrait () -> SettingsViewModel {
        return settingsDict[KEY_LOCK_PORTRAIT]!
    }
    
    func getLockToLandscape () -> SettingsViewModel {
        return settingsDict[KEY_LOCK_LANSCAPE]!
    }
    
    func getCloseButton () -> SettingsViewModel {
        return settingsDict[KEY_CLOSE_BUTTON]!
    }
    
    func getAutoClose () -> SettingsViewModel {
        return settingsDict[KEY_AUTO_CLOSE]!
    }
    
    func getSmallClick () -> SettingsViewModel {
        return settingsDict[KEY_SMALL_CLICK]!
    }
    
    func getParentalGateValue () -> Bool {
        return getParentalGate().getItemValue()
    }
    
    func getTransparentBgValue () -> Bool {
        return getTransparentBg().getItemValue()
    }
    
    func getLockToPortraitValue () -> Bool {
        return getLockToPortrait().getItemValue()
    }
    
    func getLockToLandscapeValue () -> Bool {
        return getLockToLandscape().getItemValue()
    }
    
    func getCloseButtonValue () -> Bool {
        return getCloseButton().getItemValue()
    }
    
    func getAutoCloseValue () -> Bool {
        return getAutoClose().getItemValue()
    }
    
    func getSmallClickValue () -> Bool {
        return getSmallClick().getItemValue()
    }
    
}
