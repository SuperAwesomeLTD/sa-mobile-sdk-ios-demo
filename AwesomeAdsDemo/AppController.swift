//
//  AppController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 07/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxTableAndCollectionView

class AppController: SABaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var rxTable: RxTableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserWorker.getCompany()
            .map { (company) -> [Any] in
             
                return company.data.map { app -> [Any] in
                    return [app] + app.placements.map { placement -> PlacementViewModel in
                        return PlacementViewModel(withPlacement: placement)
                    }
                }.reduce([]) { (acc, cur) -> [Any] in
                    return acc + cur
                }
            }
            .subscribe(onSuccess: { data in
                
                self.rxTable = RxTableView.create()
                    .bind(toTable: self.tableView)
                    .customise(rowForReuseIdentifier: "AppRowID", andHeight: UITableViewAutomaticDimension) { (i, row: AppRow, model: App) in
                      
                        row.appName.text = model.name
                    }
                    .customise(rowForReuseIdentifier: "PlacementRowID", andHeight: UITableViewAutomaticDimension) { (i, row: PlacementRow, model: PlacementViewModel) in
                        
                        row.placementName.text = model.placementName
                        row.placementID.text = model.placementId
                        row.placementSize.text = model.placementSize
                        row.placementIcon.image = model.placementIcon
                        
                    }
                    .did(clickOnRowWithReuseIdentifier: "PlacementRowID") { (index, model: PlacementViewModel) in
                        
                        self.performSegue("AppToCreatives")
                            .subscribe(onNext: { (dest: CreativesController) in
                                dest.placementId = model.placement.id!
                            })
                            .addDisposableTo(self.disposeBag)
                    }
                
                self.rxTable?.update(withData: data)
                
            }, onError: { error in
                // error
            })
            .addDisposableTo(disposeBag)
    }
}
