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
        
        if let format = self.placement.format, format == "video" {
            return UIImage(named: "video")
        }
        else if let _ = self.placement.format,
            let width = self.placement.width,
            let height = self.placement.height {
            
            switch (width, height) {
            case (720, 90): return UIImage(named: "leaderboard")
            case (300, 250): return UIImage(named: "mpu")
            case (468, 60): return UIImage(named: "imac468x60")
            case (120, 600): return UIImage(named: "imac120x600")
            case (300, 600): return UIImage(named: "imac300x600")
            case (160, 600): return UIImage(named: "imac160x600")
            case (970, 250): return UIImage(named: "imac970x250")
            case (970, 90): return UIImage(named: "imac970x90")
            case (300, 50): return UIImage(named: "smallbanner")
            case (320, 50): return UIImage(named: "banner")
            case (728, 90): return UIImage(named: "leaderboard")
            case (320, 480): return UIImage(named: "small_inter_port")
            case (400, 600): return UIImage(named: "small_inter_port")
            case (768, 1024): return UIImage(named: "large_inter_port")
            case (480, 320): return UIImage(named: "small_inter_land")
            case (600, 400): return UIImage(named: "small_inter_land")
            case (1024, 768): return UIImage(named: "large_inter_land")
            default: return UIImage(named: "icon_placeholder")
            }
        }
        else {
            return UIImage(named: "icon_placeholder")
        }
    }
}
