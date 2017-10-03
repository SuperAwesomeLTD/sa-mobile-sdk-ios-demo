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
    
    private var currentState: AppState {
        return (store?.getCurrentState())!
    }
    
    private var profile: UserProfile? {
        let profileState = currentState.profileState
        let profile = profileState?.profile
        return profile
    }
    
    private var jwtToken: String {
        let loginState = currentState.loginState
        let token = loginState?.jwtToken ?? ""
        return token
    }
    
    var viewModel: MainViewModel = MainViewModel()
    
    fileprivate var recogn: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeCompButton.setTitle("page_main_change_company".localized, for: .normal)
        appPlacementSearch.placeholder = "page_main_search_placeholder".localized
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.125
        
        recogn = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store?.dispatch(Event.loadApps(forCompany: (profile?.companyId)!, andJwtToken: jwtToken))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.appPlacementSearch.resignFirstResponder()
        
        if let dest = segue.destination as? CompaniesController {
            
            dest.selectedCompany = { companyId in 
                DataStore.shared.profile?.companyId = companyId
                self.appPlacementSearch.text = ""
                self.appPlacementSearch.resignFirstResponder()
            }
        }
    }
    
    override func handle(_ state: AppState) {
        viewModel.data = state.appState.apps
        tableView.reloadData()
    }
}

extension MainController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store?.dispatch(Event.FilterApps(withSearchTerm: searchText))
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(recogn)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.appPlacementSearch.resignFirstResponder()
        self.view.removeGestureRecognizer(recogn)
    }
}
