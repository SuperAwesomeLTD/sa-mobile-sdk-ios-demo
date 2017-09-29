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

    @IBOutlet weak var changeCompButton: UIButton!
    @IBOutlet weak var appPlacementSearch: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var rxTable: RxTableView?
    
    fileprivate var recogn: UITapGestureRecognizer!
    
    fileprivate var searchTerm: String?
    fileprivate var appData: [App] = []
    fileprivate var viewModels: [MainViewModel] {
        return appData
            .map { (app: App) -> [MainViewModel] in
                let appVm = AppViewModel(withApp: app)
                let plcVm = app.placements
                    .map { (placement: Placement) -> PlacementViewModel in
                        return PlacementViewModel(withPlacement: placement)
                    }
                    .filter { model -> Bool in
                        if let filter = self.searchTerm, filter != "" {
                            return model.searcheableText.lowercased().contains(filter.lowercased())
                        } else {
                            return true
                        }
                    }
    
                if plcVm.count > 0 {
                    return [appVm] + plcVm
                } else {
                    return []
                }
            }
            .reduce([]) { (acc, cur) -> [MainViewModel] in
                return acc + cur
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeCompButton.setTitle("page_main_change_company".localized, for: .normal)
        appPlacementSearch.placeholder = "page_main_search_placeholder".localized
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.125
        
        recogn = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        rxTable = RxTableView.create()
            .bind(toTable: tableView)
            .customise(rowForReuseIdentifier: "AppRowID", andHeight: UITableViewAutomaticDimension) { (i, row: AppRow, model: AppViewModel) in
                
                row.appName.text = model.app.name
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
        
        self.appPlacementSearch.resignFirstResponder()
        
        if let dest = segue.destination as? CompaniesController {
            
            dest.selectedCompany = { companyId in 
                DataStore.shared.profile?.companyId = companyId
                self.searchTerm = nil
                self.appPlacementSearch.text = ""
                self.appPlacementSearch.resignFirstResponder()
                self.loadData()
            }
        }
    }
}

extension MainController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
        self.rxTable?.update(withData: self.viewModels)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(recogn)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.appPlacementSearch.resignFirstResponder()
        self.view.removeGestureRecognizer(recogn)
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
            .subscribe(onSuccess: { (apps: NetworkData<App>) in
                self.appData = apps.data
                self.rxTable?.update(withData: self.viewModels)
            }, onError: { error in
                // error
            })
            .addDisposableTo(self.disposeBag)
    }
}
