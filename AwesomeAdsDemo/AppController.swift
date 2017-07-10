//
//  AppController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 07/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxTableAndCollectionView

class AppController: SABaseViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var rxTable: RxTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rxTable = RxTableView.create()
            .bind(toTable: tableView)
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
        
        //
        // load 
        loadData()
    }
}

//
// extension business logic
extension AppController {
    
    func loadData() {
        
        guard let token = DataStore.shared.jwtToken else {
            return
        }
        
        UserWorker.getProfile(forToken: token)
            .flatMap { profile -> Single<NetworkData<App>> in
                return UserWorker.getApps(forCompany: profile.companyId!, andToken: token)
            }
            .map { apps -> [Any] in
                
                return apps.data.map { app -> [Any] in
                    return [app] + app.placements.map { placement -> PlacementViewModel in
                        return PlacementViewModel(withPlacement: placement)
                    }
                    }.reduce([]) { (acc, cur) -> [Any] in
                        return acc + cur
                }
            }
            .subscribe(onSuccess: { data in
                self.rxTable?.update(withData: data)
            }, onError: { error in
                // error
            })
            .addDisposableTo(self.disposeBag)
    }
}
