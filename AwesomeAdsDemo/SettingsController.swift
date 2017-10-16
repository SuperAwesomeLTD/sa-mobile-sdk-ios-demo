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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "Settings".localized
        loadButton.setTitle("page_settings_button_load".localized, for: .normal)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let selectedCreative = store.current.creativesState.selectedCreative
        store.dispatch(Event.loadAdResponse(forCreative: selectedCreative))
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loadAction(_ sender: Any) {
        
        guard let response = store.current.adState.response else {
            return
        }
        
        let format = store.current.adState.format
        
        if (format.isBannerType()) {
            self.playBanner(response: response, format: format, provider: viewModel)
        }
        else if (format.isInterstitialType()) {
            self.playInterstitial(response: response, provider: viewModel)
        }
        else if (format.isVideoType()) {
            self.playVideo(response: response, provider: viewModel)
        }
        else if (format.isAppWallType()) {
            // do nothing
        }
    }
    
    override func handle(_ state: AppState) {
        
        let adState = state.adState
        
        if adState.format == .unknown {
            self.showError ()
        }
        
        viewModel.adFormat = adState.format
        dataSource.data = viewModel.viewModels
        tableView.reloadData()
        activityIndicator.isHidden = adState.response != nil
        tableView.isHidden = !(adState.response != nil)
    }
}

extension SettingsController {
    
    func playBanner (response: SAResponse, format: AdFormat, provider: SettingsViewModel) {
        
        self.performSegue("SettingsToDisplay")
            .subscribe(onNext: { (dest: DisplayController) in
                
                dest.parentalGate = provider.getParentalGateValue()
                dest.bumperPage = provider.getBumperPageValue()
                dest.bgColor = provider.getTransparentBgValue()
                dest.format = format
                dest.response = response
                
            })
            .addDisposableTo(disposeBag)
    }
}

extension SettingsController {
    
    func playInterstitial (response: SAResponse, provider: SettingsViewModel) {

        let ad = response.ads.object(at: 0) as! SAAd
        
        SAInterstitialAd.setParentalGate(provider.getParentalGateValue())
        SAInterstitialAd.setBumperPage(provider.getBumperPageValue())
        SAInterstitialAd.setOrientation(
            provider.getLockToLandscapeValue() ? .LANDSCAPE :
                provider.getLockToPortraitValue() ? .PORTRAIT : .ANY)
        SAInterstitialAd.setAd(ad)
        SAInterstitialAd.play(ad.placementId, fromVC: self)
    }
}

extension SettingsController {
    
    func playVideo (response: SAResponse, provider: SettingsViewModel) {

        let ad = response.ads.object(at: 0) as! SAAd

        SAVideoAd.setParentalGate(provider.getParentalGateValue())
        SAVideoAd.setBumperPage(provider.getBumperPageValue())
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

extension SettingsController {
    
    fileprivate func showError () {
        SAAlert.getInstance().show(withTitle: "page_creatives_popup_error_load_title".localized,
                                   andMessage: "page_creatives_popup_error_load_message".localized,
                                   andOKTitle: "page_creatives_popup_error_load_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default) { (pos, val) in
                                    _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
