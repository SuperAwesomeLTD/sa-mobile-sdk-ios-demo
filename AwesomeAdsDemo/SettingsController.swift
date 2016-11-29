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
    
    // the ad preload object
    let disposeBag = DisposeBag ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare view controller
        self.makeSASmallNavigationController(withTitle: "Settings")
        
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
                    // do nothing
                }, onError: { (error) in
                    SAActivityView.sharedManager().hide()
                }, onCompleted: { 
                    SAActivityView.sharedManager().hide()
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
        Observable.combineLatest(buttonRx, loadRx) { (_, format: AdFormat) -> Bool in
                return format == AdFormat.smallbanner ||
                       format == AdFormat.normalbanner ||
                       format == AdFormat.bigbanner ||
                       format == AdFormat.mpu
            }
            .filter { (value) -> Bool in
                return value
            }
            .map { (value) -> Void in
                return Void()
            }
            .subscribe(onNext: {
                
                self.performSegue(withIdentifier: "SettingsToDisplay", sender: self, onSegue: { (destination) in
                    
                })
    
            }).addDisposableTo(disposeBag)
        
        // act on the loading and button observables together to make a
        // decision for the interstitial type ad
        Observable.combineLatest(buttonRx, loadRx) { (_, format: AdFormat) -> AdFormat in
                return format
            }
            .filter { (format) -> Bool in
                return format == .interstitial
            }
            .map({ (format) -> Void in
                return Void()
            })
            .subscribe(onNext: {
                
                // get latest values from the provider
                let pid = self.placementId
                let test = self.test
                let pg = provider.getParentalGate().getItemValue()
                let portrait = provider.getLockToPortrait().getItemValue()
                let landscape = provider.getLockToLandscape().getItemValue()
                
                // setup & load
                SAInterstitialAd.setTestMode(test)
                SAInterstitialAd.setParentalGate(pg)
                SAInterstitialAd.setOrientation(landscape ? .LANDSCAPE : portrait ? .PORTRAIT : .ANY)
                SAInterstitialAd.load(pid)
                
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
            .map { (format) -> Void in
                return Void()
            }
            .subscribe(onNext: {
            
                // get latest values from the provider
                let pid = self.placementId
                let test = self.test
                let pg = provider.getParentalGate().getItemValue()
                let portrait = provider.getLockToPortrait().getItemValue()
                let landscape = provider.getLockToLandscape().getItemValue()
                let closebtn = provider.getCloseButton().getItemValue()
                let autoclose = provider.getAutoClose().getItemValue()
                let smallclick = provider.getSmallClick().getItemValue()
                
                // setup & load
                SAVideoAd.setTestMode(test)
                SAVideoAd.setParentalGate(pg)
                SAVideoAd.setOrientation(landscape ? .LANDSCAPE : portrait ? .PORTRAIT : .ANY)
                SAVideoAd.setCloseButton(closebtn)
                SAVideoAd.setCloseAtEnd(autoclose)
                SAVideoAd.setSmallClick(smallclick)
                SAVideoAd.load(pid)
                
            })
            .addDisposableTo(disposeBag)
        
        // add handlers
        SAInterstitialAd.setCallback { (placementId: Int, event: SAEvent) in
            if event == .adLoaded {
                SAInterstitialAd.play(placementId, fromVC: self)
            }
        }
        
        SAVideoAd.setCallback { (placementId: Int, event: SAEvent) in
            if event == .adLoaded {
                SAVideoAd.play(placementId, fromVC: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
