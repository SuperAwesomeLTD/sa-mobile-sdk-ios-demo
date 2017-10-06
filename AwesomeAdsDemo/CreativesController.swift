import UIKit
import RxSwift
import RxCocoa
import SAUtils
import SuperAwesome
import SAModelSpace
import SAAdLoader
import Kingfisher
import RxTableAndCollectionView

class CreativesController: SABaseViewController, CreativesDataSourceDelegate {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var recogn: UITapGestureRecognizer!
    
    var viewModel = CreativesViewModel ()
    var dataSource = CreativesDataSource ()
    
//    var rxTable: RxTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "page_creatives_search_placeholder".localized
        
        titleText.text = "Select Ad".localized
        
        recogn = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        dataSource.delegate = self
        
//        rxTable = RxTableView
//            .create()
//            .bind(toTable: tableView)
//            .customise(rowForReuseIdentifier: "CreativeRowID", andHeight: UITableViewAutomaticDimension) { (index, cell: CreativeRow, model: CreativeViewModel) in
//
//                // set the default image no matter what
//                cell.icon.image = UIImage(named: "icon_placeholder")
//
//                // set the proper image now
//                switch model.getCreative().format {
//                case .image:
//
//                    if let urlStr = model.getImageThumbnailUrl(), let url = URL(string: urlStr) {
//                        cell.icon.kf.setImage(with: url)
//                    }
//                    else {
//                        cell.icon.image = UIImage (named: model.getLocalUrl())
//                    }
//
//                    break
//                case .video:
//
//                    if let mid = model.getVideoMidpointThumbnailUrl(),
//                        let st = model.getVideoStartThumbnailUrl(),
//                        let midUrl = URL(string: mid),
//                        let stUrl = URL(string: st) {
//
//                        ImageDownloader.default.downloadImage(with: midUrl, options: [], progressBlock: nil) { image, error, url, data in
//
//                            if let image = image {
//                                cell.icon.image = image
//                            }
//                            else {
//
//                                ImageDownloader.default.downloadImage(with: stUrl, options: [], progressBlock: nil) { image1, error1, url1, data1 in
//
//                                    if let image = image1 {
//                                        cell.icon.image = image
//                                    }
//                                    else {
//                                        cell.icon.image = UIImage (named: model.getLocalUrl())
//                                    }
//
//                                }
//                            }
//
//                        }
//
//                    }
//                    else {
//                        cell.icon.image = UIImage (named: model.getLocalUrl())
//                    }
//
//                    break
//                case .tag, .rich, .appwall, .invalid:
//                    cell.icon.image = UIImage (named: model.getLocalUrl())
//                    break
//                }
//
////                cell.backgroundColor = index.row % 2 == 0 ? UIColor.white : UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1)
////                cell.name.text = model.getName()
////                cell.format.text = model.getCreativeFormat()
////                cell.source.text = model.getSource()
////                cell.os.text = model.getOSTarget()
//
//            }
//            .did(clickOnRowWithReuseIdentifier: "CreativeRowID") { (index, model: CreativeViewModel) in
//
//                self.searchBar.resignFirstResponder()
//
//                let ad = SAAd ()
////                ad.placementId = self.placementId
//                ad.lineItemId = 10000;
//                ad.creative = model.getCreative()
//                if ad.creative.format == .tag && ad.creative.details.format.contains("video") {
//                    ad.creative.format = .video
//                    ad.creative.details.vast = ad.creative.details.tag
//                }
//
//                self.performSegue("CreativesToSettings")
//                    .subscribe(onNext: { (dest: SettingsController) in
//                        dest.ad = ad
//                    })
//                    .addDisposableTo(self.disposeBag)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(Event.loadCreatives(forPlacementId: store.getCurrentState().selectedPlacement!))
    }

    fileprivate func loadAdError () {
        SAAlert.getInstance().show(withTitle: "page_creatives_popup_error_load_title".localized,
                                   andMessage: "page_creatives_popup_error_load_message".localized,
                                   andOKTitle: "page_creatives_popup_error_load_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default) { (pos, val) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func unsupportedFormatError () {
        
        SAAlert.getInstance().show(withTitle: "page_creatives_popup_error_format_title".localized,
                                   andMessage: "page_creatives_popup_error_format_message".localized,
                                   andOKTitle: "page_creatives_popup_error_format_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default,
                                   andPressed: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func handle(_ state: AppState) {
        viewModel.data = state.creativesState.filtered
        dataSource.data = viewModel.viewModels
        tableView.reloadData()
    }
    
    func didSelect(placementId id: Int?, andCreative: SACreative) {
        
        self.searchBar.resignFirstResponder()
        
        let ad = SAAd ()
        ad.lineItemId = 10000;
        ad.creative = andCreative
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
}

extension CreativesController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store.dispatch(Event.FilterCreatives(withSearchTerm: searchText))
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(recogn)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(recogn)
    }
}

