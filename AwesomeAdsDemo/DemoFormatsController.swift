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
    private var dataSource2: RxDataSource2?
    private var dataSource: RxDataSource?
    private let provider = DemoFormatsProvider ()
    
    private var ad: SAAd?
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        provider.getDemoFormats()
            .toArray()
            .subscribe(onNext: { (dataArry: [DemoFormatsViewModel]) in
                
                self.dataSource2 =  RxDataSource2
                    .create()
                    .bindTable(self.tableView)
                    .estimateRowHeight(101)
                    .customiseRow(identifier: "DemoFormatsRowID",
                                  modelType: DemoFormatsViewModel.self,
                                  cellType: DemoFormatsRow.self,
                                  cellHeight: 0,
                                  customise: { cell, model in
                        
                        cell.icon.image = UIImage(named: model.getSource())
                        cell.title.text = model.getName()
                        cell.details.text = model.getDetails()
                        
                    })
                    .clickRow(withIdentifier: "DemoFormatsRowID",
                              forModel: DemoFormatsViewModel.self,
                              onClick: { (index, model) in
                        
                        SALoadScreen.getInstance().show()
                        
                        SuperAwesome.loadTestAd(placementId: model.getPlacementId())
                            .do(onNext: { ad in
                                self.ad = ad
                            })
                            .flatMap { ad -> Observable<SettingsController> in
                                return self.performSegue("DemoToSettings")
                            }
                            .subscribe (onNext: { (dest: SettingsController) in
                                dest.ad = self.ad
                            }, onError: { error in
                                SALoadScreen.getInstance().hide()
                            }, onCompleted: {
                                SALoadScreen.getInstance().hide()
                            })
                            .addDisposableTo(self.disposeBag)
                        
                    })
                self.dataSource2?.update(dataArry)
                
            })
            .addDisposableTo(disposeBag)
    }
}
