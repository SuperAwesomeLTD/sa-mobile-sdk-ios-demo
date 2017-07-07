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
import RxTableAndCollectionView

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
                    .customise(rowForReuseIdentifier: "DemoFormatsRowID", andHeight: UITableViewAutomaticDimension) { (index, row: DemoFormatsRow, model: DemoFormatsViewModel) in
                        
                        row.backgroundColor = index.row % 2 == 0 ? UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1) : UIColor.white
                        row.icon.image = UIImage(named: model.getSource())
                        row.title.text = model.getName()
                        row.details.text = model.getDetails()
                        
                    }
                    .did(clickOnRowWithReuseIdentifier: "DemoFormatsRowID") { (index, model: DemoFormatsViewModel) in
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
                
                self.rxTable?.update(withData: dataArry)
                
            })
            .addDisposableTo(disposeBag)
    }
}
