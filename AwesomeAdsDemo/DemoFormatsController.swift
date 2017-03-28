//
//  DemoFormatsController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SuperAwesome
import SAModelSpace
import SAUtils

class DemoFormatsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // private vars
    private var dataSource: RxDataSource?
    private let provider = DemoFormatsProvider ()
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        provider.getDemoFormats()
            .toArray()
            .subscribe(onNext: { (dataArry: [DemoFormatsViewModel]) in
                
                self.dataSource = RxDataSource
                    .bindTable(self.tableView)
                    .estimateRowHeight(101)
                    .customiseRow(cellIdentifier: "DemoFormatsRowID",
                                  cellType: DemoFormatsViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? DemoFormatsRow
                        let model = model as? DemoFormatsViewModel
                        
                        cell?.icon.image = UIImage(named: (model?.getSource())!)
                        cell?.title.text = model?.getName()
                        cell?.details.text = model?.getDetails()
                        
                    }
                    .clickRow(cellIdentifier: "DemoFormatsRowID")
                    { (index, model) in
                        
                        let model = model as? DemoFormatsViewModel
                        
                        SALoadScreen.getInstance().show()
                        
                        // load ad
                        SuperAwesome.loadTestAd(placementId: model!.getPlacementId())
                            .subscribe(onNext: { (ad: SAAd) in
                                
                                // goto next screen
                                self.performSegue(withIdentifier: "DemoToSettings", sender: self) { (segue, sender) in
                                    
                                    if let dest = segue.destination as? SettingsController {
                                        dest.ad = ad
                                    }
                                    
                                }
                                
                            }, onError: { (error) in
                                SALoadScreen.getInstance().hide()
                            }, onCompleted: { 
                                SALoadScreen.getInstance().hide()
                            })
                            .addDisposableTo(self.disposeBag)
                    }
                
                self.dataSource?.update(dataArry)
                
            })
            .addDisposableTo(disposeBag)
    }
}
