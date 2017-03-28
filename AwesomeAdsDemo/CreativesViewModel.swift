import UIKit
import SAModelSpace

class CreativesViewModel: NSObject {
    
    private let cdnUrl: String = "https://s3-eu-west-1.amazonaws.com/beta-ads-video-transcoded-thumbnails/"
    private var adFormat: AdFormat = .unknown
    private var creative: SACreative!
    private var bitmapUrl: String?
    private var localImage: String!
    
    init (_ creative: SACreative) {
        self.creative = creative
        self.adFormat = AdFormat.fromCreative(creative)
        
        switch creative.format {
        case .invalid, .rich, .tag, .appwall:
            bitmapUrl = nil
            break
        case .image:
            bitmapUrl = creative.details.image
            break
        case .video:
            let videoUrl = creative.details.video
            if videoUrl != nil {
                let parts = videoUrl?.components(separatedBy: "/")
                if let parts = parts, parts.count > 0 {
                    let name = parts[parts.count - 1].replacingOccurrences(of: ".mp4", with: "-low-00001.jpg")
                    bitmapUrl = cdnUrl + name
                }
            }
            break
        }
        
        switch adFormat {
        case .unknown:
            localImage = "icon_placeholder"
            break
        case .smallbanner:
            localImage = "smallbanner"
            break
        case .normalbanner:
            localImage = "banner"
            break
        case .bigbanner:
            localImage = "leaderboard"
            break
        case .mpu:
            localImage = "mpu"
            break
        case .mobile_portrait_interstitial:
            localImage = "small_inter_port"
            break
        case .mobile_landscape_interstitial:
            localImage = "small_inter_land"
            break
        case .tablet_portrait_interstitial:
            localImage = "large_inter_port"
            break
        case .tablet_landscape_interstitial:
            localImage = "large_inter_land"
            break
        case .video:
            localImage = "video"
            break
        case .gamewall:
            localImage = "appwall"
            break
        }
    }
    
    func getName () -> String {
        return creative.name
    }
    
    func getSource () -> String {
        var source = "Source: "
        switch creative.format {
        case .invalid:
            source += "Unknown"
            break
        case .image:
            source += "Image"
            break
        case .video:
            source += "MP4 Video"
            break
        case .rich:
            source += "Rich Media"
            break
        case .tag:
            source += "3rd Party Tag"
            break
        case .appwall:
            source += "App Wall"
            break
        }
        
        return source
    }
    
    func getFormat () -> String {
        return "Format: \(self.adFormat.toString())"
    }
    
    func getBitmapUrl () -> String? {
        return bitmapUrl
    }
    
    func getLocalImage () -> String {
        return localImage!
    }

}
