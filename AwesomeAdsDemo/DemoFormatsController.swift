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

class DemoFormatsController: UIViewController, UITableViewDelegate {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // other vars
    let disposeBag = DisposeBag()
    private var currentPlacementId: Int = 0
    private var placementId: Int = 0
    private var test: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSABigNavigationController()
        
        let provider = DemoFormatsProvider()
        
        provider.getDemoFormats().toArray()
        .bindTo(tableView.rx.items(cellIdentifier: DemoFormatsRow.Identifier, cellType: DemoFormatsRow.self)) { index, model, row in
            
            row.icon.image = UIImage(named: model.getSource())
            row.title.text = model.getName()
            row.details.text = model.getDetails()
                
        }.addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(DemoFormatsViewModel.self).subscribe(onNext: { model in
        
            self.placementId = model.getPlacementId()
            self.test = true
            self.performSegue(withIdentifier: "DemoToSettings", sender: self)
            
        }).addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
           let dest = nav.viewControllers.first as? SettingsController
        {
            dest.placementId = self.placementId
            dest.test = self.test
        }
    }
}
