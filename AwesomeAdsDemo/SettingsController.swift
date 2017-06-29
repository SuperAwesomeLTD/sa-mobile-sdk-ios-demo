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
import RxTableView

class SettingsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    // state vars to know what to load
    var ad: SAAd!
    
    // constants needed
    let provider = SettingsProvider ()
    var rxTable: RxTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localise
        loadButton.setTitle("page_settings_button_load".localized, for: .normal)
        
        SALoadScreen.getInstance().show()
        
        // process the ad that's come from the segue
        SuperAwesome.processAd(ad: ad)
            .subscribe(onNext: { response in
                
                let format = AdFormat.fromResponse(response)
                
                // get all the active settings array based on the
                // format of the ad being processed
                self.provider.getSettings(forAdFormat: format)
                    .filter { settings -> Bool in
                        return settings.getActive()
                    }
                    .toArray()
                    .subscribe(onNext: { dataArry in
                        
                        self.rxTable = RxTableView
                            .create()
                            .bind(toTable: self.tableView)
                            .estimateRowHeight(250)
                            .customiseRow(forReuseIdentifier: "SettingsRowID") { (index, cell: SettingsRow, model: SettingsViewModel) in
                                
                                cell.backgroundColor = index.row % 2 == 0 ? UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1) : UIColor.white
                                cell.settingsItem?.text = model.getItemTitle()
                                cell.settingsDescription?.text = model.getItemDetails()
                                cell.settingsSwitch.isOn = model.getItemValue()
                                
                                cell.settingsSwitch.rx.value
                                    .subscribe(onNext: { val in
                                        model.setValue(val)
                                    })
                                    .addDisposableTo(self.disposeBag)
                                
                            }
                        self.rxTable?.update(dataArry)
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
                // manage clicks
                self.loadButton.rx.tap
                    .subscribe(onNext: {
                        
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
                
                
            }, onError: { error in
                
                SALoadScreen.getInstance().hide()
            
            }, onCompleted: {
                
                SALoadScreen.getInstance().hide()
                
            })
            .addDisposableTo(disposeBag)
    }
    
    func playBanner (response: SAResponse, format: AdFormat, provider: SettingsProvider) {
        
        self.performSegue("SettingsToDisplay")
            .subscribe(onNext: { (dest: DisplayController) in
                
                dest.parentalGate = provider.getParentalGateValue()
                dest.bgColor = provider.getTransparentBgValue()
                dest.format = format
                dest.response = response
                
            })
            .addDisposableTo(disposeBag)
    }
    
    func playInterstitial (response: SAResponse, provider: SettingsProvider) {
        
        let ad = response.ads.object(at: 0) as! SAAd
        
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
