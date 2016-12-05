//
//  DemoFormatsController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DemoFormatsController: SABaseViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // private vars
    private var currentModel: DemoFormatsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSABigNavigationController()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 101
        
        let provider = DemoFormatsProvider()
        
        // bind provider to table
        provider.getDemoFormats().toArray()
            .bindTo(tableView.rx.items(cellIdentifier: DemoFormatsRow.Identifier, cellType: DemoFormatsRow.self)) { index, model, row in
            
                row.icon.image = UIImage(named: model.getSource())
                row.title.text = model.getName()
                row.details.text = model.getDetails()
                
            }.addDisposableTo(disposeBag)
        
        // bind selection for table
        tableView.rx.modelSelected(DemoFormatsViewModel.self)
            .do(onNext: { (model) in
                self.currentModel = model
            })
            .flatMap { (model) -> Observable<UIViewController> in
                return self.rxSeque(withIdentifier: "DemoToSettings")
            }
            .subscribe(onNext: { (destination) in
                
                if let nav = destination as? UINavigationController, let dest = nav.viewControllers.first as? SettingsController {
                    dest.placementId = self.currentModel.getPlacementId()
                    dest.test = true
                }
                
            })
            .addDisposableTo(disposeBag)
    }
}
