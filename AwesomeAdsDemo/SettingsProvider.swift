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
            KEY_PARENTAL_GATE   : SettingsViewModel(item: "Parental gate enabled",
                                                    details: "Enabling this setting means that users will be greeted by a Parental Gate before proceeding to the click through destination. The Parental Gate will only allow them to go forward if they perform a simple mathematical operation.",
                                                    value: true),
            KEY_TRANSPARENT_BG  : SettingsViewModel(item: "Transparent background color",
                                                    details: "This setting controls whether a display ad (banner, MPU, etc) will have a solid grey background or a transparent one.",
                                                    value: false),
            KEY_LOCK_PORTRAIT   : SettingsViewModel(item: "Lock to portrait",
                                                    details: "Enabling this setting will lock the ad unit to portrait mode, irrespective of the user's original lock setting. This is useful when you're sure ads running on your placements are better displayed in portrait mode (e.g. rich media interstitials). Cannot be set at the same time as 'Lock to landscape'.",
                                                    value: false),
            KEY_LOCK_LANSCAPE   : SettingsViewModel(item: "Lock to landscape",
                                                    details: "Enabling this setting will lock the ad unit to landscape mode, irrespective of the user's original lock setting. This is useful when you're sure ads running on your placements are better displayed in landscape mode (e.g. video ads). Cannot be set at the same time as 'Lock to portrait'.",
                                                    value: false),
            KEY_CLOSE_BUTTON    : SettingsViewModel(item: "Close button",
                                                    details: "This setting controls whether video ads will allow for a close button to appear in the top-right corner of the ad. This will allow users to close ads before they have finished running in full. It is enabled by default. Must always be anabled if 'Auto close at end' is disabled.",
                                                    value: true),
            KEY_AUTO_CLOSE      : SettingsViewModel(item: "Auto close at end",
                                                    details: "Enabling this setting will tell a video ad to automatically close when it has finished running. Disabled by default. Must always be enabled if 'Close button' is disabled.",
                                                    value: false),
            KEY_SMALL_CLICK     : SettingsViewModel(item: "Small click button",
                                                    details: "Enabling this setting will provide a video ad a small button in the bottom-left side of the screen to direct the user to the click through. This setting is disabled by default, and the full video surface is clickable.",
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
            case .interstitial:
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
