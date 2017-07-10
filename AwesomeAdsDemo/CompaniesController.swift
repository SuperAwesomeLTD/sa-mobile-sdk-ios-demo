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
    @IBOutlet weak var searchField: SATextField!
    
    fileprivate var rxTable: RxTableView?
    
    var selectedCompany: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageTitle.text = "page_companies_title".localized
        searchField.placeholder = "page_comapanies_search_placeholder".localized
        
        rxTable = RxTableView.create()
            .bind(toTable: tableView)
            .customise(rowForReuseIdentifier: "CompanyRowID", andHeight: 60) { (i, row: CompanyRow, model: Company) in
                
                row.companyName.text = model.name!
                row.backgroundColor = i.row % 2 == 0 ? UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1) : UIColor.white
                
            }
            .did(clickOnRowWithReuseIdentifier: "CompanyRowID") { (i, model: Company) in
                self.navigationController?.popViewController(animated: true)
                self.selectedCompany?(model.id!)
            }
        
        searchField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { search -> [Any] in
                
                if search.isEmpty {
                    return DataStore.shared.companies
                } else {
                    return DataStore.shared.companies.filter { company -> Bool in
                        return company.name!.capitalized.contains(search.capitalized)
                    }
                }
            }
            .subscribe(onNext: { companies in
                self.rxTable?.update(withData: companies)
            })
            .addDisposableTo(disposeBag)
        
        //
        // get all companies
        getAllCompanies()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//
// business logic
extension CompaniesController {
    
    func getAllCompanies() {
        
        guard let token = DataStore.shared.jwtToken else {
            return
        }
        
        UserWorker.getCompanies(forJWTToken: token)
            .subscribe(onSuccess: { companies in
                
                self.rxTable?.update(withData: companies)
                
            }, onError: { error in
                // do nothing
            })
            .addDisposableTo(self.disposeBag)
    }
}
