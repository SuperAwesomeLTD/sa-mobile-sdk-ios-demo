//
//  SettingsViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class SettingsViewModel: NSObject {

    private let KEY_PARENTAL_GATE = 1
    private let KEY_BUMPER_PAGE = 2
    private let KEY_TRANSPARENT_BG = 3
    private let KEY_LOCK_PORTRAIT = 4
    private let KEY_LOCK_LANSCAPE = 5
    private let KEY_CLOSE_BUTTON = 6
    private let KEY_AUTO_CLOSE = 7
    private let KEY_SMALL_CLICK = 8
    
    private var settingsDict: [Int:SettingViewModel] = [:]
    
    override init() {
        settingsDict = [
            KEY_PARENTAL_GATE   : SettingViewModel(item: "page_settings_row_pg_gate_title".localized,
                                                   details: "page_settings_row_pg_gate_details".localized,
                                                   value: false,
                                                   index: KEY_PARENTAL_GATE),
            KEY_BUMPER_PAGE     : SettingViewModel(item: "page_settings_row_bumper_page_title".localized,
                                                   details: "page_settings_row_bumper_page_details".localized,
                                                   value: false,
                                                   index: KEY_BUMPER_PAGE),
            KEY_TRANSPARENT_BG  : SettingViewModel(item: "page_settings_row_bg_color_title".localized,
                                                   details: "page_settings_row_bg_color_details".localized,
                                                   value: false,
                                                   index: KEY_TRANSPARENT_BG),
            KEY_LOCK_PORTRAIT   : SettingViewModel(item: "page_settings_row_lock_portrait_title".localized,
                                                   details: "page_settings_row_lock_portrait_details".localized,
                                                   value: false,
                                                   index: KEY_LOCK_PORTRAIT),
            KEY_LOCK_LANSCAPE   : SettingViewModel(item: "page_settings_row_lock_landscape_title".localized,
                                                   details: "page_settings_row_lock_landscape_details".localized,
                                                   value: false,
                                                   index: KEY_LOCK_LANSCAPE),
            KEY_CLOSE_BUTTON    : SettingViewModel(item: "page_settings_row_close_button_title".localized,
                                                   details: "page_settings_row_close_button_details".localized,
                                                   value: false,
                                                   index: KEY_CLOSE_BUTTON),
            KEY_AUTO_CLOSE      : SettingViewModel(item: "page_settings_row_auto_close_title".localized,
                                                   details: "page_settings_row_auto_close_details".localized,
                                                   value: true,
                                                   index: KEY_AUTO_CLOSE),
            KEY_SMALL_CLICK     : SettingViewModel(item: "page_settings_row_small_click_title".localized,
                                                   details: "page_settings_row_small_click_details".localized,
                                                   value: false,
                                                   index: KEY_SMALL_CLICK),
        ]
    }
    
    var viewModels: [SettingViewModel] = []
    var adFormat: AdFormat = AdFormat.unknown {
        didSet {
            
            getBumperPage().setActive(true)
            getParentalGate().setActive(true)
            
            if (adFormat.isBannerType()) {
                getTransparentBg().setActive(true)
            } else if (adFormat.isInterstitialType()) {
                getLockToPortrait().setActive(true)
                getLockToLandscape().setActive(true)
            } else if (adFormat.isVideoType()) {
                getLockToPortrait().setActive(true)
                getLockToLandscape().setActive(true)
                getCloseButton().setActive(true)
                getAutoClose().setActive(true)
                getSmallClick().setActive(true)
            }
            
            viewModels = []
            for i in 1...8 {
                if let setting = self.settingsDict[i] as? SettingViewModel, setting.getActive() {
                    viewModels.append(setting)
                }
            }
        }
    }
    
    func getParentalGate () -> SettingViewModel {
        return settingsDict[KEY_PARENTAL_GATE]!
    }
    
    func getBumperPage () -> SettingViewModel {
        return settingsDict[KEY_BUMPER_PAGE]!
    }
    
    func getTransparentBg () -> SettingViewModel {
        return settingsDict[KEY_TRANSPARENT_BG]!
    }
    
    func getLockToPortrait () -> SettingViewModel {
        return settingsDict[KEY_LOCK_PORTRAIT]!
    }
    
    func getLockToLandscape () -> SettingViewModel {
        return settingsDict[KEY_LOCK_LANSCAPE]!
    }
    
    func getCloseButton () -> SettingViewModel {
        return settingsDict[KEY_CLOSE_BUTTON]!
    }
    
    func getAutoClose () -> SettingViewModel {
        return settingsDict[KEY_AUTO_CLOSE]!
    }
    
    func getSmallClick () -> SettingViewModel {
        return settingsDict[KEY_SMALL_CLICK]!
    }
    
    func getParentalGateValue () -> Bool {
        return getParentalGate().getItemValue()
    }
    
    func getBumperPageValue () -> Bool {
        return getBumperPage().getItemValue()
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
