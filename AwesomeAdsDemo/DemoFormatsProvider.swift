//
//  DemoFormatsProvider.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DemoFormatsProvider: NSObject {

    func getDemoFormats () -> Observable <DemoFormatsViewModel> {
        return Observable.create({ (observer) -> Disposable in
            
            let data: [DemoFormatsViewModel] = [
                DemoFormatsViewModel(placementId: 30472,
                                     image: "smallbanner",
                                     name: "demo_controller_table_row_1_title".localized,
                                     details: "demo_controller_table_row_1_details".localized),
                DemoFormatsViewModel(placementId: 30471,
                                     image: "banner",
                                     name: "demo_controller_table_row_2_title".localized,
                                     details: "demo_controller_table_row_2_details".localized),
                DemoFormatsViewModel(placementId: 30475,
                                     image: "leaderboard",
                                     name: "demo_controller_table_row_3_title".localized,
                                     details: "demo_controller_table_row_3_details".localized),
                DemoFormatsViewModel(placementId: 30476,
                                     image: "mpu",
                                     name: "demo_controller_table_row_4_title".localized,
                                     details: "demo_controller_table_row_4_details".localized),
                DemoFormatsViewModel(placementId: 30473,
                                     image: "small_inter_port",
                                     name: "demo_controller_table_row_5_title".localized,
                                     details: "demo_controller_table_row_5_details".localized),
                DemoFormatsViewModel(placementId: 30474,
                                     image: "small_inter_land",
                                     name: "demo_controller_table_row_6_title".localized,
                                     details: "demo_controller_table_row_6_details".localized),
                DemoFormatsViewModel(placementId: 30477,
                                     image: "large_inter_port",
                                     name: "demo_controller_table_row_7_title".localized,
                                     details: "demo_controller_table_row_7_details".localized),
                DemoFormatsViewModel(placementId: 30478,
                                     image: "large_inter_land",
                                     name: "demo_controller_table_row_8_title".localized,
                                     details: "demo_controller_table_row_8_details".localized),
                DemoFormatsViewModel(placementId: 30479,
                                     image: "video",
                                     name: "demo_controller_table_row_9_title".localized,
                                     details: "demo_controller_table_row_9_details".localized)
            ]
            
            for d in data {
                observer.onNext(d)
            }
            observer.onCompleted()
            
            return Disposables.create()
        })
    }
    
}
