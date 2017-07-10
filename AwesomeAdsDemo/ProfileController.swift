//
//  ProfileController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 10/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTableAndCollectionView

//
// basic
class ProfileController: SABaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var rxTable: RxTableView?
    
    var goBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "page_profile_title".localized
        
        rxTable = RxTableView.create()
            .bind(toTable: tableView)
            .customise(rowForReuseIdentifier: "ProfileRowID", andHeight: 44) { (i, row: ProfileRow, model: ProfileViewModel) in
             
                row.backgroundColor = i.row % 2 == 0 ? UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1) : UIColor.white
                row.profileLabel.text = model.fieldName
                row.profileValue.text = model.fieldValue
                row.profileValue.textColor = model.isActive ? UIColor(colorLiteralRed: 37.0/255.0, green: 110.0/255.0, blue: 255.0/255.0, alpha: 1) : UIColor.black
                
            }
            .did(clickOnRowWithReuseIdentifier: "ProfileRowID") { (i, model: ProfileViewModel) in
                
                if model.isActive {
                    self.performSegue("ProfileToCompanies")
                }
            }
        
        //
        //
        self.getProfile()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.goBack?()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? CompaniesController {
            dest.selectedCompany = { companyId in
                DataStore.shared.profile?.companyId = companyId
                self.getProfile()
            }
        }
    }
}

//
// logic
extension ProfileController {
    
    func getProfile () {
        
        guard let token = DataStore.shared.jwtToken else { return }
        
        UserWorker.getProfile(forToken: token)
            .subscribe(onSuccess: { profile in
                
                var models: [ProfileViewModel] = []
                models.append(ProfileViewModel(withFieldName: "Username", andFieldValue: profile.username!, andActive: false))
                models.append(ProfileViewModel(withFieldName: "Email", andFieldValue: profile.email!, andActive: false))
                models.append(ProfileViewModel(withFieldName: "Phone", andFieldValue: profile.phone!, andActive: false))
                
                UserWorker.getCompany(forId: profile.companyId!, andJWTToken: token)
                    .subscribe(onSuccess: { company in
                        
                        models.append(ProfileViewModel(withFieldName: "Company", andFieldValue: company.name!, andActive: profile.canImpersonate))
                        self.rxTable?.update(withData: models)
                        
                    }, onError: { error in
                        // do nothing
                    })
                    .addDisposableTo(self.disposeBag)
            }, onError: { error in
                // do nothing
            })
            .addDisposableTo(disposeBag)
    }
}
