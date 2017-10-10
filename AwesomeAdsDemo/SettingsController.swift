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
import SAAdLoader
import SAModelSpace
import RxTableAndCollectionView

class SettingsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataSource = SettingsDataSource()
    var viewModel = SettingsViewModel()
    
    // state vars to know what to load
//    var ad: SAAd!
    
//    // constants needed
//    let provider = SettingsProvider ()
//    var rxTable: RxTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "Settings".localized
        loadButton.setTitle("page_settings_button_load".localized, for: .normal)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        SALoadScreen.getInstance().show()
//
//        // process the ad that's come from the segue
//        SALoader.processAd(ad: ad)
//            .subscribe(onNext: { response in
//
//                let format = AdFormat.fromResponse(response)
//
//                // get all the active settings array based on the
//                // format of the ad being processed
//                self.provider.getSettings(forAdFormat: format)
//                    .filter { settings -> Bool in
//                        return settings.getActive()
//                    }
//                    .toArray()
//                    .subscribe(onNext: { dataArry in
//
//                        self.rxTable = RxTableView
//                            .create()
//                            .bind(toTable: self.tableView)
//                            .customise(rowForReuseIdentifier: "SettingsRowID", andHeight: UITableViewAutomaticDimension) { (index, cell: SettingsRow, model: SettingsViewModel) in
//
//                                cell.backgroundColor = index.row % 2 == 0 ? UIColor.white : UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1)
//                                cell.settingsItem?.text = model.getItemTitle()
//                                cell.settingsDescription?.text = model.getItemDetails()
//                                cell.settingsSwitch.isOn = model.getItemValue()
//
//                                cell.settingsSwitch.rx.value
//                                    .subscribe(onNext: { val in
//                                        model.setValue(val)
//                                    })
//                                    .addDisposableTo(self.disposeBag)
//
//                            }
//                        self.rxTable?.update(withData: dataArry)
//
//                    })
//                    .addDisposableTo(self.disposeBag)
//
//                // manage clicks
//                self.loadButton.rx.tap
//                    .subscribe(onNext: {
//
//                        if (format.isBannerType()) {
//                            self.playBanner(response: response, format: format, provider: self.provider)
//                        }
//                        else if (format.isInterstitialType()) {
//                            self.playInterstitial(response: response, provider: self.provider)
//                        }
//                        else if (format.isVideoType()) {
//                            self.playVideo(response: response, provider: self.provider)
//                        }
//                        else if (format.isAppWallType()) {
//                            // do nothing
//                        }
//
//                    })
//                    .addDisposableTo(self.disposeBag)
//
//
//            }, onError: { error in
//
//                SALoadScreen.getInstance().hide()
//
//            }, onCompleted: {
//
//                SALoadScreen.getInstance().hide()
//
//            })
//            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let selectedCreative = store.current.creativesState.selectedCreative
        store.dispatch(Event.loadAdResponse(forCreative: selectedCreative))
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func handle(_ state: AppState) {
        
        let adState = state.adState
        
        if adState.format == .unknown {
            // showError ()
        }
        
        viewModel.adFormat = adState.format
        dataSource.data = viewModel.viewModels
        tableView.reloadData()
        activityIndicator.isHidden = adState.response != nil
        tableView.isHidden = !(adState.response != nil)
    }
}

extension SettingsController {
    
//    func playBanner (response: SAResponse, format: AdFormat, provider: SettingsProvider) {
//        
//        self.performSegue("SettingsToDisplay")
//            .subscribe(onNext: { (dest: DisplayController) in
//                
//                dest.parentalGate = provider.getParentalGateValue()
//                dest.bgColor = provider.getTransparentBgValue()
//                dest.format = format
//                dest.response = response
//                
//            })
//            .addDisposableTo(disposeBag)
//    }
}

extension SettingsController {
    
//    func playInterstitial (response: SAResponse, provider: SettingsProvider) {
//
//        guard let
//
//        SAInterstitialAd.setParentalGate(provider.getParentalGateValue())
//        SAInterstitialAd.setOrientation(
//            provider.getLockToLandscapeValue() ? .LANDSCAPE :
//                provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
//        SAInterstitialAd.setAd(ad)
//        SAInterstitialAd.play(ad.placementId, fromVC: self)
//    }
}

extension SettingsController {
    
//    func playVideo (response: SAResponse, provider: SettingsProvider) {
//
//        let ad = response.ads.object(at: 0) as! SAAd
//
//        SAVideoAd.setParentalGate(provider.getParentalGateValue())
//        SAVideoAd.setOrientation(
//            provider.getLockToLandscapeValue() ? .LANDSCAPE :
//                provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
//        SAVideoAd.setCloseButton(provider.getCloseButtonValue())
//        SAVideoAd.setCloseAtEnd(provider.getAutoCloseValue())
//        SAVideoAd.setSmallClick(provider.getSmallClickValue())
//        SAVideoAd.setAd(ad)
//        SAVideoAd.play(ad.placementId, fromVC: self)
//    }
}
