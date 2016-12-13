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
    private var dataSource: RxDataSource?
    private let provider = DemoFormatsProvider ()
    
    override func viewDidLoad () {
        super.viewDidLoad()

        provider.getDemoFormats()
            .toArray()
            .subscribe(onNext: { (dataArry: [DemoFormatsViewModel]) in
                
                self.dataSource = RxDataSource
                    .bindTable(self.tableView)
                    .estimateRowHeight(101)
                    .customiseRow(cellIdentifier: "DemoFormatsRowID",
                                  cellType: DemoFormatsViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? DemoFormatsRow
                        let model = model as? DemoFormatsViewModel
                        
                        cell?.icon.image = UIImage(named: (model?.getSource())!)
                        cell?.title.text = model?.getName()
                        cell?.details.text = model?.getDetails()
                        
                    }
                    .clickRow(cellIdentifier: "DemoFormatsRowID")
                    { (index, model) in
                        
                        self.currentModel = model as? DemoFormatsViewModel
                        self.performSegue(withIdentifier: "DemoToSettings", sender: self)
                        
                    }
                
                self.dataSource?.update(dataArry)
                
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "demo_controller_title".localized
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? SettingsController {
            destination.placementId = self.currentModel.getPlacementId()
            destination.test = true
            
        }
    }
}
