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

class SettingsController: UIViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    // state vars to know what to load
    var format: AdFormat = .unknown
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
        
        let preload = AdPreload ()
        let provider = SettingsProvider ()
        
        // preload an ad and bind to a table
        preload.loadAd(placementId: placementId, test: test)
            .do(onNext: { (format) in
                    self.format = format
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
                
            }.addDisposableTo(disposeBag)
        
        // handle button being pressed
        loadButton.rx.tap
            .subscribe (onNext: { Void in
                
                
                
            }).addDisposableTo(disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
