//
//  CompaniesDataSource.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 03/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

protocol CompaniesDataSourceDelegate {
    func didSelect(company comp: Company)
}

class CompaniesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var data: [CompanyViewModel] = []
    var delegate: CompaniesDataSourceDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyRow.Identifier, for: indexPath) as! CompanyRow
        cell.viewModel = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        let company = model.company
        delegate?.didSelect(company: company)
    }
}
