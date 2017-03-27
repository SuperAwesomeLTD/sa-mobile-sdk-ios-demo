import UIKit
import SAModelSpace

class CreativesViewModel: NSObject {
    
    private var creative: SACreative!
    
    init (_ creative: SACreative) {
        self.creative = creative
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
        return "AwesomeAds ad"
    }

}
