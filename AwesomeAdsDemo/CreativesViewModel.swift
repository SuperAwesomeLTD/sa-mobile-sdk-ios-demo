import UIKit
import SAModelSpace

class CreativesViewModel: NSObject {
    
    private let cdnUrl: String = "https://s3-eu-west-1.amazonaws.com/beta-ads-video-transcoded-thumbnails/"
    private var adFormat: AdFormat = .unknown
    private var creative: SACreative!
    
    
    private var imageThumbnailUrl: String?
    private var videoMidpointThumbnailUrl: String?
    private var videoStartThumbnailUrl: String?
    private var localUrl: String!
    
    init (_ creative: SACreative) {
        self.creative = creative
        self.adFormat = AdFormat.fromCreative(creative)
        
        switch creative.format {
        case .invalid, .rich, .tag, .appwall:
            // do nothing
            break
        case .image:
            imageThumbnailUrl = creative.details.image
            break
        case .video:
            let videoUrl = creative.details.video
            if videoUrl != nil {
                let parts = videoUrl?.components(separatedBy: "/")
                if let parts = parts, parts.count > 0 {
                    let startName = parts[parts.count - 1].replacingOccurrences(of: ".mp4", with: "-low-00001.jpg")
                    videoStartThumbnailUrl = cdnUrl + startName
                    let midpointName = parts[parts.count - 1].replacingOccurrences(of: ".mp4", with: "-low-00002.jpg")
                    videoMidpointThumbnailUrl = cdnUrl + midpointName
                }
            }
            break
        }
        
        switch adFormat {
        case .unknown:
            localUrl = "icon_placeholder"
            break
        case .smallbanner:
            localUrl = "smallbanner"
            break
        case .normalbanner:
            localUrl = "banner"
            break
        case .bigbanner:
            localUrl = "leaderboard"
            break
        case .mpu:
            localUrl = "mpu"
            break
        case .mobile_portrait_interstitial:
            localUrl = "small_inter_port"
            break
        case .mobile_landscape_interstitial:
            localUrl = "small_inter_land"
            break
        case .tablet_portrait_interstitial:
            localUrl = "large_inter_port"
            break
        case .tablet_landscape_interstitial:
            localUrl = "large_inter_land"
            break
        case .video:
            localUrl = "video"
            break
        case .gamewall:
            localUrl = "appwall"
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
    
    func getFormat () -> AdFormat {
        return adFormat
    }
    
    func getCreativeFormat () -> String {
        return "Format: \(self.adFormat.toString())"
    }
    
    func getLocalUrl () -> String {
        return localUrl!
    }
    
    func getImageThumbnailUrl () -> String? {
        return imageThumbnailUrl
    }
    
    func getVideoMidpointThumbnailUrl () -> String? {
        return videoMidpointThumbnailUrl
    }
    
    func getVideoStartThumbnailUrl () -> String? {
        return videoStartThumbnailUrl
    }
    
    func getCreative () -> SACreative {
        return creative!
    }
    
    func getOSTarget () -> String {
        var os = "System: "
        if let targets = creative.osTarget as? [String] {
            os += targets.count == 0 ? "All" : targets.joined(separator: ",")
        } else {
            os += "N/A"
        }
        return os
    }
}
