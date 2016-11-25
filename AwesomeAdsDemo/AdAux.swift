//
//  AdAux.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SuperAwesome

class AdAux: NSObject {

    func determineAdType (_ response: SAResponse?) -> AdFormat {
        
        if let response = response {
            
            if response.format == .gamewall {
                return .gamewall
            }
            else if response.format == .video {
                return .video
            }
            else if response.format == .invalid {
                return .unknown
            }
            else {
                if response.ads.count > 0, let ad = response.ads.firstObject as? SAAd {
                    
                    let width = ad.creative.details.width
                    let height = ad.creative.details.height
                    
                    if width == 300 && height == 50 {
                        return .smallbanner
                    }
                    if width == 320 && height == 50 {
                        return .normalbanner
                    }
                    if width == 728 && height == 90 {
                        return .bigbanner
                    }
                    if width == 300 && height == 250 {
                        return .mpu
                    }
                    if width == 320 && height == 480 {
                        return .interstitial
                    }
                    if width == 480 && height == 320 {
                        return .interstitial
                    }
                    if width == 768 && height == 1024 {
                        return .interstitial
                    }
                    if width == 1024 && height == 768 {
                        return .interstitial
                    }
                    
                    return .unknown
                    
                } else {
                    return .unknown
                }
            }
            
        } else {
            return .unknown
        }
    }
    
}
