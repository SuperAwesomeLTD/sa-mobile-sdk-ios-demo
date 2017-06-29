import UIKit
import RxSwift
import RxCocoa
import SAUtils
import SuperAwesome
import SAModelSpace
import Kingfisher
import RxTableView

class CreativesController: SABaseViewController {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    
    // state vars to know what to load
    var placementId: Int = 0
    var rxTable: RxTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "Select Ad".localized
        SALoadScreen.getInstance().show()
        
        SuperAwesome.loadCreatives(placementId: placementId)
            .map { creative -> CreativesViewModel in
                return CreativesViewModel (creative)
            }
            .toArray()
            .map { creatives -> [CreativesViewModel] in
                return creatives.sorted(by: { m1, m2 -> Bool in
                    return m1.getName() < m2.getName()
                })
            }
            .subscribe(onNext: { (creatives: [CreativesViewModel]) in
                
                self.rxTable = RxTableView
                    .create()
                    .bind(toTable: self.tableView)
                    .estimateRowHeight(130)
                    .customiseRow(forReuseIdentifier: "CreativesRowID") { (index, cell: CreativesRow, model: CreativesViewModel) in
                        
                        // set the default image no matter what
                        cell.icon.image = UIImage(named: "icon_placeholder")
                        
                        // set the proper image now
                        switch model.getCreative().format {
                        case .image:
                            
                            if let urlStr = model.getImageThumbnailUrl(), let url = URL(string: urlStr) {
                                cell.icon.kf.setImage(with: url)
                            }
                            else {
                                cell.icon.image = UIImage (named: model.getLocalUrl())
                            }
                            
                            break
                        case .video:
                            
                            if let mid = model.getVideoMidpointThumbnailUrl(),
                                let st = model.getVideoStartThumbnailUrl(),
                                let midUrl = URL(string: mid),
                                let stUrl = URL(string: st) {
                                
                                ImageDownloader.default.downloadImage(with: midUrl, options: [], progressBlock: nil) { image, error, url, data in
                                    
                                    if let image = image {
                                        cell.icon.image = image
                                    }
                                    else {
                                        
                                        ImageDownloader.default.downloadImage(with: stUrl, options: [], progressBlock: nil) { image1, error1, url1, data1 in
                                            
                                            if let image = image1 {
                                                cell.icon.image = image
                                            }
                                            else {
                                                cell.icon.image = UIImage (named: model.getLocalUrl())
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                            else {
                                cell.icon.image = UIImage (named: model.getLocalUrl())
                            }
                            
                            break
                        case .tag, .rich, .appwall, .invalid:
                            cell.icon.image = UIImage (named: model.getLocalUrl())
                            break
                        }
                        
                        cell.backgroundColor = index.row % 2 == 0 ? UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1) : UIColor.white
                        cell.name.text = model.getName()
                        cell.format.text = model.getCreativeFormat()
                        cell.source.text = model.getSource()
                        cell.os.text = model.getOSTarget()
                        
                    }
                    .clickRow(forReuseIdentifier: "CreativesRowID") { (index, model: CreativesViewModel) in
                        
                        if model.getFormat() != .unknown {
                            
                            let ad = SAAd ()
                            ad.placementId = self.placementId
                            ad.lineItemId = 10000;
                            ad.creative = model.getCreative()
                            if ad.creative.format == .tag && ad.creative.details.format.contains("video") {
                                ad.creative.format = .video
                                ad.creative.details.vast = ad.creative.details.tag
                            }
                            
                            self.performSegue("CreativesToSettings")
                                .subscribe(onNext: { (dest: SettingsController) in
                                    dest.ad = ad
                                })
                                .addDisposableTo(self.disposeBag)
                            
                        }
                        else {
                            self.unsupportedFormatError()
                        }
                    }
                self.rxTable?.update(creatives)
                
            }, onError: { error in
                
                SALoadScreen.getInstance().hide()
                self.loadAdError()
                
            }, onCompleted: {
                SALoadScreen.getInstance().hide()
            })
            .addDisposableTo(disposeBag)
    }

    private func loadAdError () {
        SAAlert.getInstance().show(withTitle: "page_creatives_popup_error_load_title".localized,
                                   andMessage: "page_creatives_popup_error_load_message".localized,
                                   andOKTitle: "page_creatives_popup_error_load_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default) { (pos, val) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func unsupportedFormatError () {
        
        SAAlert.getInstance().show(withTitle: "page_creatives_popup_error_format_title".localized,
                                   andMessage: "page_creatives_popup_error_format_message".localized,
                                   andOKTitle: "page_creatives_popup_error_format_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default,
                                   andPressed: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
