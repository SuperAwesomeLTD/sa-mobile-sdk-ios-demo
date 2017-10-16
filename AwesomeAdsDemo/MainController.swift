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
    
    var viewModel: MainViewModel = MainViewModel ()
    var dataSource: MainDataSource = MainDataSource ()
    
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
        
        dataSource.delegate = self
        
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store?.dispatch(Event.loadApps(forCompany: store.company.id!, andJwtToken: store.jwtToken))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.appPlacementSearch.resignFirstResponder()
        self.appPlacementSearch.text = ""
    }
    
    override func handle(_ state: AppState) {
        changeCompButton.isHidden = !(state.profileState?.canImpersonate ?? true)
        viewModel.data = state.appState.filtered
        dataSource.sections = viewModel.sections
        tableView.reloadData()
    }
}

extension MainController: MainDataSourceDelegate {
    func didSelect(placementId placId: Int?) {
        store?.dispatch(Event.SelectPlacement(placementId: placId))
        performSegue("MainToCreatives")
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
