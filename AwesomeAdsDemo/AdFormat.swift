//
//  AdFormat.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAModelSpace

enum AdFormat {
    case unknown
    case smallbanner
    case normalbanner
    case bigbanner
    case mpu
    case mobile_portrait_interstitial
    case mobile_landscape_interstitial
    case tablet_portrait_interstitial
    case tablet_landscape_interstitial
    case video
    case gamewall
    
    func toString() -> String {
        switch self {
        case .unknown: return "Unknown"
        case .smallbanner: return "Mobile Small Leaderboard"
        case .normalbanner: return "Mobile Leaderboard"
        case .bigbanner: return "Tablet Leaderboard"
        case .mpu: return "Tablet MPU"
        case .mobile_portrait_interstitial: return "Mobile Interstitial Portrait"
        case .mobile_landscape_interstitial: return "Mobile Interstitial Landscape"
        case .tablet_portrait_interstitial: return "Tablet Interstitial Portrait"
        case .tablet_landscape_interstitial: return "Tablet Interstitial Landscape"
        case .video: return "Mobile Video"
        case .gamewall: return "App Wall"
        }
    }
    
    static func fromCreative (_ creative: SACreative?) -> AdFormat {
        
        if let creative = creative {
            switch creative.format {
            case .invalid:
                return .unknown
            case .video:
                return .video
            case .appwall:
                return .gamewall
            case .image, .tag, .rich:
                
                if (creative.details.format.contains("video")) {
                    return .video
                }
                else {
                    let width = creative.details.width
                    let height = creative.details.height
                    
                    switch (width, height) {
                    case (720, 90): return .bigbanner
                    case (300, 250): return .mpu
                    case (468, 60): return .normalbanner
                    case (120, 600): return .mpu
                    case (300, 600): return .mpu
                    case (160, 600): return .mpu
                    case (970, 250): return .bigbanner
                    case (970, 90): return .bigbanner
                    case (300, 50): return .smallbanner
                    case (320, 50): return .smallbanner
                    case (728, 90): return .bigbanner
                    case (320, 480): return .mobile_portrait_interstitial
                    case (400, 600): return .mobile_portrait_interstitial
                    case (768, 1024): return .tablet_portrait_interstitial
                    case (480, 320): return .mobile_landscape_interstitial
                    case (600, 400): return .mobile_landscape_interstitial
                    case (1024, 768): return .tablet_landscape_interstitial
                    default: return .unknown
                    }
                }
            }
        }
        else {
            return .unknown
        }
        
    }
    
    static func fromResponse (_ response: SAResponse?) -> AdFormat {
        
        if let response = response {
            
            if response.format == .appwall {
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
                    
                    switch (width, height) {
                    case (720, 90): return .bigbanner
                    case (300, 250): return .mpu
                    case (468, 60): return .normalbanner
                    case (120, 600): return .mpu
                    case (300, 600): return .mpu
                    case (160, 600): return .mpu
                    case (970, 250): return .bigbanner
                    case (970, 90): return .bigbanner
                    case (300, 50): return .smallbanner
                    case (320, 50): return .smallbanner
                    case (728, 90): return .bigbanner
                    case (320, 480): return .mobile_portrait_interstitial
                    case (400, 600): return .mobile_portrait_interstitial
                    case (768, 1024): return .tablet_portrait_interstitial
                    case (480, 320): return .mobile_landscape_interstitial
                    case (600, 400): return .mobile_landscape_interstitial
                    case (1024, 768): return .tablet_landscape_interstitial
                    default: return .unknown
                    }
                    
                } else {
                    return .unknown
                }
            }
            
        } else {
            return .unknown
        }
    }
    
    func isBannerType () -> Bool {
        return self == .smallbanner ||
            self == .bigbanner ||
            self == .normalbanner ||
            self == .mpu
    }
    
    func isInterstitialType () -> Bool {
        return self == .mobile_portrait_interstitial ||
            self == .mobile_landscape_interstitial ||
            self == .tablet_portrait_interstitial ||
            self == .tablet_landscape_interstitial
    }
    
    func isVideoType () -> Bool {
        return self == .video
    }
    
    func isAppWallType () -> Bool {
        return self == .gamewall
    }
    
    func isUnknownType () -> Bool {
        return self == .unknown
    }
}
