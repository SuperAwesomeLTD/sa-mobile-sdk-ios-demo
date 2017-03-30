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
import RxTableView

class DemoFormatsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // private vars
    private var rxTable: RxTableView?
    private let provider = DemoFormatsProvider ()
    private var ad: SAAd?
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        provider.getDemoFormats()
            .toArray()
            .subscribe(onNext: { (dataArry: [DemoFormatsViewModel]) in
                
                
                self.rxTable = RxTableView
                    .create()
                    .bind(toTable: self.tableView)
                    .estimateRowHeight(101)
                    .customiseRow(forReuseIdentifier: "DemoFormatsRowID") { (index, cell: DemoFormatsRow, model: DemoFormatsViewModel) in
                        
                        cell.icon.image = UIImage(named: model.getSource())
                        cell.title.text = model.getName()
                        cell.details.text = model.getDetails()
                        
                    }
                    .clickRow(forReuseIdentifier: "DemoFormatsRowID") { (index, model: DemoFormatsViewModel) in
                        
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
                        
                    }
                
                self.rxTable?.update(dataArry)
                
            })
            .addDisposableTo(disposeBag)
    }
}
