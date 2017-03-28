import UIKit
import RxSwift
import RxCocoa
import SAUtils
import SuperAwesome
import SAModelSpace
import Kingfisher

class CreativesController: SABaseViewController {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // state vars to know what to load
    var placementId: Int = 0
    var dataSource: RxDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SALoadScreen.getInstance().show()
        
        SuperAwesome.loadCreatives(placementId: placementId)
            .map({ (creative) -> CreativesViewModel in
                return CreativesViewModel (creative)
            })
            .toArray()
            .subscribe(onNext: { (creatives: [CreativesViewModel]) in
                
                self.dataSource = RxDataSource
                    .bindTable(self.tableView)
                    .estimateRowHeight(110)
                    .customiseRow(cellIdentifier: "CreativesRowID", cellType: CreativesViewModel.self, customise: { (model, cell) in
                        
                        let cell = cell as? CreativesRow
                        let model = model as? CreativesViewModel
                        
                        if let bitmap = model?.getBitmapUrl() {
                            cell?.icon.kf.setImage(with: URL(string: bitmap))
                        }
                        else {
                            cell?.icon.image = UIImage(named: model!.getLocalImage())
                        }
                        
                        cell?.name.text = model?.getName()
                        cell?.format.text = model?.getFormat()
                        cell?.source.text = model?.getSource()
                    })
                
                self.dataSource?.update(creatives)
                
            }, onError: { (error) in
                
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
