//
//  PlacementViewModel.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class PlacementViewModel: MainViewModel {
    
    var placement: Placement
    
    init(withPlacement placement: Placement) {
        self.placement = placement
        
        super.init()
        
        if let id = placement.id, let name = placement.name {
            super.searcheableText = "\(id)_\(name)"
        }
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
            
            if width == 300 && height == 50 {
                return UIImage(named: "smallbanner")
            }
            if width == 320 && height == 50 {
                return UIImage(named: "banner")
            }
            if width == 728 && height == 90 {
                return UIImage(named: "leaderboard")
            }
            if width == 300 && height == 250 {
                return UIImage(named: "mpu")
            }
            if width == 320 && height == 480 {
                return UIImage(named: "small_inter_port")
            }
            if width == 480 && height == 320 {
                return UIImage(named: "small_inter_land")
            }
            if width == 768 && height == 1024 {
                return UIImage(named: "large_inter_port")
            }
            if width == 1024 && height == 768 {
                return UIImage(named: "large_inter_land")
            }
            if width == 120 && height == 600 {
                return UIImage(named: "imac120x600")
            }
            if width == 160 && height == 600 {
                return UIImage(named: "imac160x600")
            }
            if width == 300 && height == 600 {
                return UIImage(named: "imac300x600")
            }
            if width == 468 && height == 60 {
                return UIImage(named: "imac468x60")
            }
            if width == 970 && height == 90 {
                return UIImage(named: "imac970x90")
            }
            if width == 970 && height == 250 {
                return UIImage(named: "imac970x250")
            }
            
            return UIImage(named: "icon_placeholder")
        }
        else {
            return UIImage(named: "icon_placeholder")
        }
    }
}
