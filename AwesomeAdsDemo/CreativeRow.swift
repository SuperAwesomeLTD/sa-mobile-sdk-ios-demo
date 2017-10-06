import UIKit
import Kingfisher

class CreativeRow: UITableViewCell {

    static let Identifier = "CreativeRowID"
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var format: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var os: UILabel!
    
    var viewModel: CreativeViewModel! {
        didSet {
            
            backgroundColor = viewModel.backgroundColor
            name.text = viewModel.name
            format.text = viewModel.creativeFormat
            source.text = viewModel.source
            os.text = viewModel.osTarget
            
            // set the default image no matter what
            icon.image = UIImage(named: "icon_placeholder")
            
            // set the proper image now
            switch viewModel.getCreative().format {
            case .image:
                
                if let urlStr = viewModel.getImageThumbnailUrl(), let url = URL(string: urlStr) {
                    icon.kf.setImage(with: url)
                }
                else {
                    icon.image = UIImage (named: viewModel.getLocalUrl())
                }
                
                break
            case .video:
                
                if let mid = viewModel.getVideoMidpointThumbnailUrl(),
                    let st = viewModel.getVideoStartThumbnailUrl(),
                    let midUrl = URL(string: mid),
                    let stUrl = URL(string: st) {
                    
                    ImageDownloader.default.downloadImage(with: midUrl, options: [], progressBlock: nil) { image, error, url, data in
                        
                        if let image = image {
                            self.icon.image = image
                        }
                        else {
                            
                            ImageDownloader.default.downloadImage(with: stUrl, options: [], progressBlock: nil) { image1, error1, url1, data1 in
                                
                                if let image = image1 {
                                    self.icon.image = image
                                }
                                else {
                                    self.icon.image = UIImage (named: self.viewModel.getLocalUrl())
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                else {
                    icon.image = UIImage (named: viewModel.getLocalUrl())
                }
                
                break
            case .tag, .rich, .appwall, .invalid:
                icon.image = UIImage (named: viewModel.getLocalUrl())
                break
            }
        }
    }
}
