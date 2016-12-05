//
//  SABaseViewController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SABaseViewController: UIViewController {

    // the dispose bag object
    let disposeBag = DisposeBag ()
    private var onSegue: ((_ destination: UIViewController) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func performSegue(withIdentifier identifier: String, sender: Any?, onSegue: @escaping (_ destiantion: UIViewController) -> Void) {
        self.onSegue = onSegue
        self.performSegue(withIdentifier: identifier, sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = onSegue {
            seg(segue.destination)
        }
    }

    func rxSeque(withIdentifier identifier: String) -> Observable<UIViewController> {
        return Observable.create({ (observable) -> Disposable in
            
            self.performSegue(withIdentifier: identifier, sender: self, onSegue: { (destination) in
                
                observable.onNext(destination)
                observable.onCompleted()
                
            })
            
            return Disposables.create()
        })
    }
}
