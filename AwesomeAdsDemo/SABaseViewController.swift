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

    var store: Store<AppState>?
    
    private var prepared: ((_ segue: UIStoryboardSegue, _ sender: Any?) -> Void)?
    
    let disposeBag = DisposeBag ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let del = UIApplication.shared.delegate as! AppDelegate
        store = del.store
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func performSegue (_ identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    func performSegue <T> (_ identifier: String) -> Observable<T> {
        
        return Observable.create { subscriber -> Disposable in
         
            self.performSegue(withIdentifier: identifier, sender: self, prepared: { (segue, sender) in
                
                if let dest = segue.destination as? T {
                    subscriber.onNext(dest)
                    subscriber.onCompleted()
                }
                
            })
            
            return Disposables.create()
        }
        
    }
    
    private func performSegue(withIdentifier identifier: String, sender: Any?, prepared: @escaping ((_ segue: UIStoryboardSegue, _ sender: Any?) -> Void)) {
        self.prepared = prepared
        self.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.prepared? (segue, sender)
    }
}

extension SABaseViewController {
    
    func getChild <T: UIViewController> () -> T? {
        
        var childVC: T?
        
        self.childViewControllers.forEach { child in
            if let child = child as? T {
                childVC = child
            }
        }
        
        return childVC
    }
}
