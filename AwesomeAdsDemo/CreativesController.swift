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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(Event.loadCreatives(forPlacementId: store.current.selectedPlacement!))
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func handle(_ state: AppState) {
        
        let creativesState = state.creativesState
        
        if creativesState.creatives.count == 0 {
            loadAdError()
        }
        else {
            viewModel.data = creativesState.filtered
            dataSource.data = viewModel.viewModels
            tableView.reloadData()
        }
    }
    
    func didSelect(placementId id: Int?, andCreative creative: SACreative) {

        self.searchBar.resignFirstResponder()
        store.dispatch(Event.SelectCreative(creative: creative))
        self.performSegue("CreativesToSettings")
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

extension CreativesController {
    
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
}

