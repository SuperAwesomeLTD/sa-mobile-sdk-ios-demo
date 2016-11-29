//
//  SABaseViewController.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SABaseViewController: UIViewController {

    private var onSegue: ((_ destination: UIViewController) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func performSegue(withIdentifier identifier: String, sender: Any?, onSegue: @escaping (_ destiantion: UIViewController) -> Void) {
        self.onSegue = onSegue
        self.performSegue(withIdentifier: identifier, sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = onSegue, let dest = segue.destination as? UIViewController {
            seg(dest)
        }
    }

}
