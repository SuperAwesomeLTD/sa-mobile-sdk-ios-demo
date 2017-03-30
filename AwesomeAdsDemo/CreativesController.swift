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
    
    // state vars to know what to load
    var placementId: Int = 0
    var rxTable: RxTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SALoadScreen.getInstance().show()
        
        SuperAwesome.loadCreatives(placementId: placementId)
            .map { creative -> CreativesViewModel in
                return CreativesViewModel (creative)
            }
            .toArray()
            .subscribe(onNext: { (creatives: [CreativesViewModel]) in
                
                self.rxTable = RxTableView
                    .create()
                    .bind(toTable: self.tableView)
                    .estimateRowHeight(110)
                    .customiseRow(forReuseIdentifier: "CreativesRowID") { (index, cell: CreativesRow, model: CreativesViewModel) in
                        
                        if let bitmap = model.getBitmapUrl() {
                            cell.icon.kf.setImage(with: URL(string: bitmap))
                        }
                        else {
                            cell.icon.image = UIImage(named: model.getLocalImage())
                        }
                        
                        cell.name.text = model.getName()
                        cell.format.text = model.getFormat()
                        cell.source.text = model.getSource()
                        
                    }
                    .clickRow(forReuseIdentifier: "CreativesRowID") { (index, model: CreativesViewModel) in
                        
                        let ad = SAAd ()
                        ad.placementId = self.placementId
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
                self.rxTable?.update(creatives)
                
            }, onError: { error in
                
                SALoadScreen.getInstance().hide()
                self.creativesError()
                
            }, onCompleted: {
                SALoadScreen.getInstance().hide()
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func creativesError () {
        SAAlert.getInstance().show(withTitle: "page_creatives_popup_error_load_title".localized,
                                   andMessage: "page_creatives_popup_error_load_message".localized,
                                   andOKTitle: "page_creatives_popup_error_load_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default) { (pos, val) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
