//
//  PlacementViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class PlacementViewModel {
    
    var placement: Placement
    
    init(withPlacement placement: Placement) {
        self.placement = placement
    }
    
    var placementName: String {
        if let name = self.placement.name {
            return name
        } else {
            return "N/A"
        }
    }
    
    var placementId: String {
        if let id = self.placement.id {
            return "Placement: \(id)"
        } else {
            return "Placement: N/A"
        }
    }
    
    var placementSize: String {
        if let width = self.placement.width, let height = self.placement.height {
            return "Size: \(width)x\(height)"
        } else {
            return "Size: N/A"
        }
    }
    
    var placementIcon: UIImage? {
        
        let format = AdFormat.fromPlacement(placement: self.placement)
        var localUrl: String = ""
        
        switch format {
        case .unknown: localUrl = "icon_placeholder"; break;
        case .smallbanner: localUrl = "smallbanner"; break;
        case .banner: localUrl = "banner"; break
        case .smallleaderboard: localUrl = "imac468x60"; break;
        case .leaderboard: localUrl = "leaderboard"; break
        case .pushdown: localUrl = "imac970x90"; break;
        case .billboard: localUrl = "imac970x250"; break;
        case .skinnysky: localUrl = "imac120x600"; break
        case .sky: localUrl = "imac300x600"; break;
        case .mpu: localUrl = "mpu"; break;
        case .doublempu: localUrl = "imac300x600"; break;
        case .mobile_portrait_interstitial: localUrl = "small_inter_port"; break;
        case .mobile_landscape_interstitial: localUrl = "small_inter_land"; break;
        case .tablet_portrait_interstitial: localUrl = "large_inter_port"; break;
        case .tablet_landscape_interstitial: localUrl = "large_inter_land"; break;
        case .video: localUrl = "video"; break;
        case .gamewall: localUrl = "appwall"; break;
        }
        
        return UIImage(named: localUrl)
    }
}
