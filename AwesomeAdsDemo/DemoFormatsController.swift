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

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    private var currentPlacementId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = DemoFormatsProvider()
        
        provider.getDemoFormats().toArray()
        .bindTo(tableView.rx.items(cellIdentifier: DemoFormatsRow.Identifier, cellType: DemoFormatsRow.self)) { index, model, row in
            
            row.icon.image = UIImage(named: model.getSource())
            row.title.text = model.getName()
            row.details.text = model.getDetails()
                
        }.addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(DemoFormatsViewModel.self).subscribe(onNext: { model in
        
            let settings = self.storyboard?.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
            settings.placementId = model.getPlacementId()
            settings.test = true
            self.present(settings, animated: true, completion: nil)
            
        }).addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeSANavigationController()
    }
}
