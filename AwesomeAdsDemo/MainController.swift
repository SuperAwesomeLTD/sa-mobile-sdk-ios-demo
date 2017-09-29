//
//  MainController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import QuartzCore
import RxTableAndCollectionView
import SuperAwesome
import RxSwift
import RxCocoa

class MainController: SABaseViewController {

    @IBOutlet weak var appPlacementSearch: SATextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var yourPlacementContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var rxTable: RxTableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appPlacementSearch.placeholder = "page_main_search_placeholder".localized
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.125
        
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
                
                self.performSegue("MainToCreatives")
                    .subscribe(onNext: { (dest: CreativesController) in
                        dest.placementId = model.placement.id!
                    })
                    .addDisposableTo(self.disposeBag)
        }
        
        //
        // load
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? ProfileController {
            
            dest.goBack = {
                self.loadData()
            }
        }
    }
}

//
// extension business logic
extension MainController {
    
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
