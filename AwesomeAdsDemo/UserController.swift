import UIKit
import RxSwift
import RxCocoa
import SAUtils
import SuperAwesome

class UserController: SABaseViewController, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var placementTextView: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    // other vars
    private var currentModel: UserModel!
    private var touch: UIGestureRecognizer = UITapGestureRecognizer ()
    private var dataSource: RxDataSource?
    private var subject: PublishSubject<[UserHistory]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup localized text
        nextButton.setTitle("page_user_button_next_title".localized, for: .normal)
        placementTextView.placeholder = "page_user_textfield_placement_placeholder".localized
        
        let rightBtn = UIBarButtonItem(title: "page_user_logout_button_title".localized, style: .plain, target: self, action: #selector(logout))
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBtn
        
        // placement text view
        placementTextView.delegate = self
        placementTextView.rx.text.orEmpty
            .map { text -> UserModel in
                return UserModel(text)
            }
            .do(onNext: { userModel in
                self.currentModel = userModel
            })
            .map { userModel -> Bool in
                return userModel.isValid()
            }
            .subscribe(onNext: { isValid in
                self.nextButton.isEnabled = isValid
                self.nextButton.backgroundColor = isValid ? UIColorFromHex(0x147CCD) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // next button tap
        nextButton.rx.tap
            .subscribe (onNext: {
                
                // save to history
                DbAux.savePlacementToHistory(history: UserHistory(placementId: self.currentModel.getPlacementID()))
                
                // perform segue
                self.performSegue("UserToCreatives")
                    .subscribe(onNext: { (dest: CreativesController) in
                        dest.placementId = self.currentModel.getPlacementID()
                    })
                    .addDisposableTo(self.disposeBag)
            })
            .addDisposableTo(disposeBag)
        
        // the rows
        subject = PublishSubject.init()
        subject?.asObserver()
            .startWith(DbAux.getPlacementsFromHistory())
            .map({ (userHistories) -> [UserHistoryViewModel] in
                return userHistories.map { history -> UserHistoryViewModel in
                    return UserHistoryViewModel(history: history)
                }
            })
            .subscribe(onNext: { viewModels in
                
                self.dataSource = RxDataSource
                    .bindTable(self.table)
                    .customiseRow(cellIdentifier: "UserHistoryRowID", cellType: UserHistoryViewModel.self, cellHeight: 80) { model, cell in
                        
                        let cell = cell as? UserHistoryRow
                        let model = model as? UserHistoryViewModel
                        
                        cell?.placement.text = model?.getPlacement()
                        cell?.date.text = model?.getDate()
                        
                    }
                    .clickRow(cellIdentifier: "UserHistoryRowID") { index, model in
                        
                        let model = model as? UserHistoryViewModel
                        
                        self.performSegue("UserToCreatives")
                            .subscribe(onNext: { (dest: CreativesController) in
                                dest.placementId = model!.getPlacementId()
                            })
                            .addDisposableTo(self.disposeBag)
                        
                }
                
                self.dataSource?.update(viewModels)
                
            })
            .addDisposableTo(disposeBag)
        
        // the touch gesture recogniser
        touch.rx.event.asObservable()
            .subscribe(onNext: { (event) in
                self.placementTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let s = subject {
            s.onNext(DbAux.getPlacementsFromHistory())
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addGestureRecognizer(touch)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(touch)
    }
    
    func logout () {
        LoginManager.sharedInstance.logout()
        self.dismiss(animated: true)
    }
}
