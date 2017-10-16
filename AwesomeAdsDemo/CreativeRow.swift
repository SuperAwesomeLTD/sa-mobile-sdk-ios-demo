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
            icon.kf.setImage(with: viewModel.getRemoteUrl(),
                             placeholder: UIImage(named: viewModel.getLocalUrl()))
        }
    }
}
