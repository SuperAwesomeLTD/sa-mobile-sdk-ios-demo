//
//  CompaniesController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTableAndCollectionView

class CompaniesController: SABaseViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    
    var viewModel = CompaniesViewModel ()
    var dataSource = CompaniesDataSource ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitle.text = "page_companies_title".localized
        searchField.placeholder = "page_comapanies_search_placeholder".localized
        dataSource.store = self.store
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store?.dispatch(Event.loadCompanies(forJwtToken: jwtToken))
    }
    
    @IBAction func backAction(_ sender: Any) {
        store?.dispatch(Event.SelectCompany(companyId: companyId))
    }
    
    override func handle(_ state: AppState) {
        viewModel.data = state.companiesState.filtered
        dataSource.data = viewModel.viewModels
        tableView.reloadData()
        
        if state.companiesState.hasSelected {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CompaniesController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store?.dispatch(Event.FilterCompanies(withSearchTerm: searchText))
    }
}
