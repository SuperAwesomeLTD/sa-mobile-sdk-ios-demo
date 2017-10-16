import UIKit
import SAModelSpace

class CreativeViewModel: NSObject {
    
    private let cdnUrl: String = "https://s3-eu-west-1.amazonaws.com/beta-ads-video-transcoded-thumbnails/"
    private var adFormat: AdFormat = .unknown
    private var creative: SACreative!
    private var index: Int = 0
    private var remoteUrl: String?
    private var localUrl: String!
    
    init (withCreative creative: SACreative, atIndex index: Int) {
        self.index = index
        self.creative = creative
        self.adFormat = AdFormat.fromCreative(creative)
        
        switch creative.format {
        case .invalid, .rich, .tag, .appwall:
            // do nothing
            break
        case .image:
            remoteUrl = creative.details.image
            break
        case .video:
            let videoUrl = creative.details.video
            if videoUrl != nil {
                let parts = videoUrl?.components(separatedBy: "/")
                if let parts = parts, parts.count > 0 {
                    let startName = parts[parts.count - 1].replacingOccurrences(of: ".mp4", with: "-low-00001.jpg")
                    remoteUrl = cdnUrl + startName
                }
            }
            break
        }
        
        switch adFormat {
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
    }
    
    var name: String {
        return creative.name
    }
    
    var source: String {
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
    
    var creativeFormat: String {
        return "Format: \(self.adFormat.toString())"
    }
    
    func getLocalUrl () -> String {
        return localUrl!
    }
    
    func getRemoteUrl () -> URL? {
        if let url = remoteUrl {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    func getCreative () -> SACreative {
        return creative!
    }
    
    var osTarget: String {
        var os = "System: "
        if let targets = creative.osTarget as? [String] {
            os += targets.count == 0 ? "All" : targets.joined(separator: ",")
        } else {
            os += "N/A"
        }
        return os
    }
    
    var backgroundColor: UIColor {
        return index % 2 == 0 ?
            UIColor(rgb: 0xf7f7f7) :
            UIColor.white
    }
}
