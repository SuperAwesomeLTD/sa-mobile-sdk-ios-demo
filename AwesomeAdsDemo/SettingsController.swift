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
    
    // constants needed
    let preload = AdPreload ()
    let provider = SettingsProvider ()
    var dataSource: RxDataSource? = nil
    
    var loadRx: Observable<AdFormat>!
    var buttonRx: ControlEvent<Void>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create observables
        loadRx = preload.loadAd(placementId: placementId, test: test).share()
        buttonRx = loadButton.rx.tap
        
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
                }, onCompleted: {
                }, onSubscribe: {
            })
            .flatMap { (format) -> Observable<SettingsViewModel> in
                return self.provider.getSettings(forAdFormat: format)
            }
            .filter({ (setting: SettingsViewModel) -> Bool in
                return setting.getActive()
            })
            .toArray()
            .subscribe(onNext: { (dataArry) in
                
                self.dataSource = RxDataSource
                    .bindTable(self.tableView)
                    .estimateRowHeight(250)
                    .customiseRow(cellIdentifier: "SettingsRowID",
                                  cellType: SettingsViewModel.self)
                    { (model, cell) in
                     
                        let cell = cell as? SettingsRow
                        let model = model as? SettingsViewModel
                        
                        cell?.settingsItem?.text = model?.getItemTitle()
                        cell?.settingsDescription?.text = model?.getItemDetails()
                        cell?.settingsSwitch.isOn = (model?.getItemValue())!
                        
                        cell?.settingsSwitch.rx.value
                            .subscribe(onNext: { (val) in
                                model?.setValue(val)
                            })
                            .addDisposableTo(self.disposeBag)
                    }
                
                self.dataSource?.update(dataArry)
                
            })
            .addDisposableTo(disposeBag)
        
        // act for the case the format is unknown (and ad could not be
        // loaded correctly)
        loadRx
            .filter { (format) -> Bool in
                return format == .unknown
            }
            .subscribe(onNext: { (format) in
                // do nothing
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
            .subscribe(onNext: { (Void) in
                
                self.performSegue(withIdentifier: "SettingsToDisplay", sender: self)
                
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
                SAInterstitialAd.setParentalGate(self.provider.getParentalGateValue())
                SAInterstitialAd.setOrientation(
                    self.provider.getLockToLandscapeValue() ? .LANDSCAPE :
                        self.provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)

                
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
                SAVideoAd.setParentalGate(self.provider.getParentalGateValue())
                SAVideoAd.setOrientation(
                    self.provider.getLockToLandscapeValue() ? .LANDSCAPE :
                        self.provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
                SAVideoAd.setCloseButton(self.provider.getCloseButtonValue())
                SAVideoAd.setCloseAtEnd(self.provider.getAutoCloseValue())
                SAVideoAd.setSmallClick(self.provider.getSmallClickValue())
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? DisplayController {
            dest.headerTitle = self.headerTitle
            dest.placementId = self.placementId
            dest.test = self.test
            dest.format = self.format
            dest.parentalGate = provider.getParentalGate().getItemValue()
            dest.bgColor = provider.getTransparentBg().getItemValue()
        }
    }
}
