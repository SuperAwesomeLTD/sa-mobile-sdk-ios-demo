//
//  SettingsController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SAUtils
import SuperAwesome
import SAUtils

class SettingsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    // state vars to know what to load
    var placementId: Int = 0
    var test: Bool = false
    var headerTitle: String = ""
    var format: AdFormat = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare view controller
        self.makeSASmallNavigationController()
        
        // prepare table
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 61
        
        // create data providers
        let preload = AdPreload ()
        let provider = SettingsProvider ()
        
        // create observables
        let loadRx = preload.loadAd(placementId: placementId, test: test).share()
        let buttonRx = loadButton.rx.tap
        
        // act on the loading observable
        loadRx
            .do(onNext: { (format) in
                
                switch format {
                case .smallbanner: self.headerTitle = "Mobile Small Leaderboard"; break
                case .normalbanner: self.headerTitle = "Mobile Leaderboard"; break
                case .bigbanner: self.headerTitle = "Tablet Leaderboard"; break
                case .mpu: self.headerTitle = "Tablet MPU"; break
                case .interstitial: self.headerTitle = "Interstitial"; break
                case .video: self.headerTitle = "Video"; break
                case .gamewall: self.headerTitle = "App Wall"; break
                case .unknown: break
                }
                
                self.format = format
                
                }, onError: { (error) in
                    SAActivityView.sharedManager().hide()
                }, onCompleted: { 
                    SAActivityView.sharedManager().hide()
                    self.setSASmallNavigationControllerTitle(self.headerTitle)
                }, onSubscribe: { 
                    SAActivityView.sharedManager().show()
                })
            .flatMap { (format) -> Observable<SettingsViewModel> in
                return provider.getSettings(forAdFormat: format)
            }
            .filter({ (setting: SettingsViewModel) -> Bool in
                return setting.getActive()
            })
            .toArray()
            .bindTo(tableView.rx.items(cellIdentifier: SettingsRow.Identifier, cellType: SettingsRow.self)) { index, model, row in
                
                row.settingsItem?.text = model.getItemTitle()
                row.settingsDescription?.text = model.getItemDetails()
                row.settingsSwitch.isOn = model.getItemValue()
                
                row.settingsSwitch.rx.value.shareReplay(1)
                    .subscribe(onNext: { (val) in model.setValue(val) })
                    .addDisposableTo(self.disposeBag)
                
            }
            .addDisposableTo(disposeBag)
        
        // act for the case the format is unknown (and ad could not be
        // loaded correctly)
        loadRx
            .filter { (format) -> Bool in
                return format == .unknown
            }
            .subscribe(onNext: { (format) in
                
                SAPopup.sharedManager().show(withTitle: "Hey!",
                                             andMessage: "The Placement ID you tried to load appears to have no ad data.",
                                             andOKTitle: "Got it!",
                                             andNOKTitle: nil,
                                             andTextField: false,
                                             andKeyboardTyle: .default, andPressed: { (button, text) in
                                                self.dismiss(animated: true, completion: nil)
                                            })
                
            })
            .addDisposableTo(disposeBag)
        
        // act on the loading and button observables together to make a
        // decision for the banner type ad
        Observable.combineLatest(buttonRx, loadRx) { (_, format: AdFormat) -> AdFormat in
                return format
            }
            .filter { (format) -> Bool in
                return format == AdFormat.smallbanner ||
                       format == AdFormat.normalbanner ||
                       format == AdFormat.bigbanner ||
                       format == AdFormat.mpu

            }
            .flatMap({ (format) -> Observable<UIViewController> in
                return self.rxSeque(withIdentifier: "SettingsToDisplay")
            })
            .subscribe(onNext: { (destination) in
                
                if let nav = destination as? UINavigationController, let dest = nav.viewControllers.first as? DisplayController {
                    dest.headerTitle = self.headerTitle
                    dest.placementId = self.placementId
                    dest.test = self.test
                    dest.format = self.format
                    dest.parentalGate = provider.getParentalGate().getItemValue()
                    dest.bgColor = provider.getTransparentBg().getItemValue()
                }
                
            })
            .addDisposableTo(disposeBag)
        
        // act on the loading and button observables together to make a
        // decision for the interstitial type ad
        Observable.combineLatest(buttonRx, loadRx) { (_, format: AdFormat) -> AdFormat in
                return format
            }
            .filter { (format) -> Bool in
                return format == .interstitial
            }
            .do(onNext: { (format) in
                
                // setup & load
                SAInterstitialAd.setTestMode(self.test)
                SAInterstitialAd.setParentalGate(provider.getParentalGateValue())
                SAInterstitialAd.setOrientation(
                    provider.getLockToLandscapeValue() ? .LANDSCAPE :
                        provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)

                
            })
            .flatMap({ (format) -> Observable<SAEvent> in
                return SAInterstitialAd.loadRx(self.placementId)
            })
            .filter({ (event) -> Bool in
                return event == .adLoaded
            })
            .subscribe(onNext: { (event) in
                SAInterstitialAd.play(self.placementId, fromVC: self)
            })
            .addDisposableTo(disposeBag)
        
        // act on the loading and button observables together to make a
        // decition for the video type ad
        Observable.combineLatest(buttonRx, loadRx) { (_, format: AdFormat) -> AdFormat in
                return format
            }
            .filter { (format) -> Bool in
                return format == .video
            }
            .do(onNext: { (format) in
                
                // setup & load
                SAVideoAd.setTestMode(self.test)
                SAVideoAd.setParentalGate(provider.getParentalGateValue())
                SAVideoAd.setOrientation(
                    provider.getLockToLandscapeValue() ? .LANDSCAPE :
                        provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
                SAVideoAd.setCloseButton(provider.getCloseButtonValue())
                SAVideoAd.setCloseAtEnd(provider.getAutoCloseValue())
                SAVideoAd.setSmallClick(provider.getSmallClickValue())
                
            })
            .flatMap({ (format) -> Observable<SAEvent> in
                return SAVideoAd.loadRx(self.placementId)
            })
            .filter({ (event) -> Bool in
                return event == .adLoaded
            })
            .subscribe(onNext: { (event) in
                SAVideoAd.play(self.placementId, fromVC: self)
            })
            .addDisposableTo(disposeBag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
