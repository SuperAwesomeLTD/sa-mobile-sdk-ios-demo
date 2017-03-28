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
import SAModelSpace

class SettingsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    // state vars to know what to load
    var ad: SAAd!
    
    // constants needed
    let provider = SettingsProvider ()
    var dataSource: RxDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localise
        loadButton.setTitle("page_settings_button_load".localized, for: .normal)
        
        SALoadScreen.getInstance().show()
        
        // process the ad that's come from the segue
        SuperAwesome.processAd(ad: ad)
            .subscribe(onNext: { (response: SAResponse) in
                
                let format = AdFormat.fromResponse(response)
                
                // get all the active settings array based on the
                // format of the ad being processed
                self.provider.getSettings(forAdFormat: format)
                    .filter({ (settings: SettingsViewModel) -> Bool in
                        return settings.getActive()
                    })
                    .toArray()
                    .subscribe(onNext: { (dataArry) in
                        
                        // customise the data source
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
                    .addDisposableTo(self.disposeBag)
                
                // manage clicks
                self.loadButton.rx.tap
                    .subscribe(onNext: { () in
                        
                        if (format.isBannerType()) {
                            self.playBanner(response: response, format: format, provider: self.provider)
                        }
                        else if (format.isInterstitialType()) {
                            self.playInterstitial(response: response, provider: self.provider)
                        }
                        else if (format.isVideoType()) {
                            self.playVideo(response: response, provider: self.provider)
                        }
                        else if (format.isAppWallType()) {
                            // do nothing
                        }
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
                
            }, onError: { (error) in
                
                SALoadScreen.getInstance().hide()
            
            }, onCompleted: {
                
                SALoadScreen.getInstance().hide()
                
            })
            .addDisposableTo(disposeBag)
    }
    
    func playBanner (response: SAResponse, format: AdFormat, provider: SettingsProvider) {
        
        self.performSegue(withIdentifier: "SettingsToDisplay", sender: self) { (segue, sender) in
            
            if let dest = segue.destination as? DisplayController {
                dest.parentalGate = provider.getParentalGateValue()
                dest.bgColor = provider.getTransparentBgValue()
                dest.format = format
                dest.response = response
            }
            
        }
    }
    
    func playInterstitial (response: SAResponse, provider: SettingsProvider) {
        
        let ad = response.ads.object(at: 0) as! SAAd
        
        SAInterstitialAd.setCallback { (placement, event: SAEvent) in
            print("Event is \(event)")
        }
        SAInterstitialAd.setParentalGate(provider.getParentalGateValue())
        SAInterstitialAd.setOrientation(
            provider.getLockToLandscapeValue() ? .LANDSCAPE :
                provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
        SAInterstitialAd.setAd(ad)
        SAInterstitialAd.play(ad.placementId, fromVC: self)
    }
    
    func playVideo (response: SAResponse, provider: SettingsProvider) {
        
        let ad = response.ads.object(at: 0) as! SAAd
        
        SAVideoAd.setParentalGate(provider.getParentalGateValue())
        SAVideoAd.setOrientation(
            provider.getLockToLandscapeValue() ? .LANDSCAPE :
                provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
        SAVideoAd.setCloseButton(provider.getCloseButtonValue())
        SAVideoAd.setCloseAtEnd(provider.getAutoCloseValue())
        SAVideoAd.setSmallClick(provider.getSmallClickValue())
        SAVideoAd.setAd(ad)
        SAVideoAd.play(ad.placementId, fromVC: self)
    }
}
