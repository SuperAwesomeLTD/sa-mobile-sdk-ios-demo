//
//  AdFormat.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 25/11/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SuperAwesome

//Mobile Small Leaderboard 300x50
//Mobile Leaderboard 320x50

//Small Leaderboard 468x60
//Leaderboard 728x90
//Push down 970x90
//Billboard 970x250

//Skinny Skyscraper 120x600
//Skyscraper 160x600

//MPU 300x250
//Double MPU 300x600

//Mobile interstitial portrait 320x480 / 400x600
//Tablet interstitial portrait 768x1024
//Tablet lansdscape interstitial 1024x768
//Mobile interstitial landscape 480x320 / 600x400

//Video

//AppWall

enum AdFormat {
    case unknown
    case smallbanner
    case banner
    case smallleaderboard
    case leaderboard
    case pushdown
    case billboard
    case skinnysky
    case sky
    case mpu
    case doublempu
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
        case .banner: return "Mobile Leaderboard"
        case .smallleaderboard: return "Small Leaderboard"
        case .leaderboard: return "Tablet Leaderboard"
        case .pushdown: return "Push Down"
        case .billboard: return "Billboard"
        case .skinnysky: return "Skinny Skyscraper"
        case .sky: return "Skyscraper"
        case .mpu: return "Tablet MPU"
        case .doublempu: return "Double MPU"
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
            case .video:
                return .video
            case .appwall:
                return .gamewall
            case .image, .tag, .rich, .invalid:
                
                if let format = creative.details.format, format.contains("video") {
                    return .video
                }
                else {
                    let width = creative.details.width
                    let height = creative.details.height
                    
                    switch (width, height) {
                    case (300, 50): return .smallbanner
                    case (320, 50): return .banner
                    
                    case (468, 60): return .smallleaderboard
                    case (728, 90): return .leaderboard
                    case (970, 90): return .pushdown
                    case (970, 250): return .billboard
                        
                    case (120, 600): return .skinnysky
                    case (160, 600): return .sky
                        
                    case (300, 250): return .mpu
                    case (300, 600): return .doublempu
                    
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
                    case (300, 50): return .smallbanner
                    case (320, 50): return .banner
                        
                    case (468, 60): return .smallleaderboard
                    case (728, 90): return .leaderboard
                    case (970, 90): return .pushdown
                    case (970, 250): return .billboard
                        
                    case (120, 600): return .skinnysky
                    case (160, 600): return .sky
                        
                    case (300, 250): return .mpu
                    case (300, 600): return .doublempu
                        
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
    
    static func fromPlacement(placement: Placement) -> AdFormat {
        if let format = placement.format, format == "video" {
            return .video
        }
        else if let _ = placement.format,
            let width = placement.width,
            let height = placement.height {
            
            switch (width, height) {
            case (300, 50): return .smallbanner
            case (320, 50): return .banner
                
            case (468, 60): return .smallleaderboard
            case (728, 90): return .leaderboard
            case (970, 90): return .pushdown
            case (970, 250): return .billboard
                
            case (120, 600): return .skinnysky
            case (160, 600): return .sky
                
            case (300, 250): return .mpu
            case (300, 600): return .doublempu
                
            case (320, 480): return .mobile_portrait_interstitial
            case (400, 600): return .mobile_portrait_interstitial
            case (768, 1024): return .tablet_portrait_interstitial
            case (480, 320): return .mobile_landscape_interstitial
            case (600, 400): return .mobile_landscape_interstitial
            case (1024, 768): return .tablet_landscape_interstitial
            default: return .unknown
            }
        }
        else {
            return .unknown
        }
    }
    
    func isBannerType () -> Bool {
        return self == .smallbanner ||
            self == .banner ||
            self == .leaderboard ||
            self == .smallleaderboard ||
            self == .pushdown ||
            self == .billboard ||
            self == .skinnysky ||
            self == .sky ||
            self == .mpu ||
            self == .doublempu
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
