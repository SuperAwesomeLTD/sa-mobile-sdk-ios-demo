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
    fileprivate var rxTable: RxTableView?
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var currentCompanyLabel: UILabel!
    @IBOutlet weak var impersonateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let token = DataStore.shared.jwtToken else {
            return;
        }
        
        UserWorker.getProfile(forToken: token)
            .subscribe(onSuccess: { profile in
                
                self.usernameLabel.text = profile.username
                self.impersonateBtn.isHidden = !profile.canImpersonate
                self.getAllCompanies(withInitialId: profile.companyId)
                self.getAppsForCompany(companyId: profile.companyId!)
                
            }, onError: { error in
                // do nothing
            })
            .addDisposableTo(disposeBag)
        
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

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? CompaniesController {
            dest.selectedCompany = { companyId in
                self.getAppsForCompany(companyId: companyId)
                self.updateCurrentCompany(companyId: companyId)
            }
        }
    }
}

//
// extension business logic
extension AppController {
    
    func getAllCompanies (withInitialId id: Int?) {
        
        guard let token = DataStore.shared.jwtToken else {
            return
        }
        
        UserWorker.getCompanies(forJWTToken: token)
            .map { data -> [Company] in
                return data.data
            }
            .subscribe(onSuccess: { companies in
            
                if let id = id {
                    self.updateCurrentCompany(companyId: id)
                }
                
            }, onError: { error in
                // do nothing
            })
            .addDisposableTo(self.disposeBag)
    }
    
    func updateCurrentCompany (companyId id: Int) {
        
        let companies = DataStore.shared.companies
        
        for i in 0..<companies.count {
            if companies[i].id == id {
                self.currentCompanyLabel.text = companies[i].name
                break
            }
        }
    }
    
    func getAppsForCompany (companyId id: Int) {
        
        guard let token = DataStore.shared.jwtToken else {
            return
        }
        
        UserWorker.getApps(forCompany: id, andToken: token)
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
