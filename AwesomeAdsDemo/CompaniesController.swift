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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = CompaniesViewModel ()
    var dataSource = CompaniesDataSource ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitle.text = "page_companies_title".localized
        searchField.placeholder = "page_comapanies_search_placeholder".localized
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(Event.LoadingCompanies)
        store.dispatch(Event.loadCompanies(forJwtToken: store.jwtToken))
    }
    
    @IBAction func backAction(_ sender: Any) {
        didSelect(company: store.company)
    }
    
    override func handle(_ state: AppState) {
        let companiesState = state.companiesState
        viewModel.data = companiesState.filtered
        dataSource.data = viewModel.viewModels
        tableView.reloadData()
        
        activityIndicator.isHidden = !companiesState.isLoading
        tableView.isHidden = companiesState.isLoading
    }
}

extension CompaniesController: CompaniesDataSourceDelegate {
    
    func didSelect(company comp: Company) {
        store?.dispatch(Event.SelectCompany(company: comp))
        self.navigationController?.popViewController(animated: true)
    }
}

extension CompaniesController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store?.dispatch(Event.FilterCompanies(withSearchTerm: searchText))
    }
}
