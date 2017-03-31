import UIKit
import RxSwift
import RxCocoa
import SAUtils
import SuperAwesome
import RxTableView

class UserController: SABaseViewController {

    private let kTOP_CONTRAINT_WITH_DATA: CGFloat = 40
    private let kTOP_CONSTRANT_NO_DATA: CGFloat = 170
    
    // outlets
    @IBOutlet weak var placementTextView: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var separator: UIView!
    
    // other vars
    private var currentModel: UserModel!
    private var touch: UIGestureRecognizer = UITapGestureRecognizer ()
    private var rxTable: RxTableView?
    private var subject: PublishSubject<[UserHistory]>?
    
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup localized text
        nextButton.setTitle("page_user_button_next_title".localized, for: .normal)
        placementTextView.placeholder = "page_user_textfield_placement_placeholder".localized
        
        let rightBtn = UIBarButtonItem(title: "page_user_logout_button_title".localized, style: .plain, target: self, action: nil)
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBtn
        
        // placement text view
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
        
        placementTextView.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.view.addGestureRecognizer(self.touch)
            })
            .addDisposableTo(disposeBag)
        
        placementTextView.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                self.view.removeGestureRecognizer(self.touch)
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
                
                self.topContraint.constant = viewModels.count == 0 ? self.kTOP_CONSTRANT_NO_DATA : self.kTOP_CONTRAINT_WITH_DATA
                self.separator.isHidden = viewModels.count == 0
                
                self.rxTable = RxTableView
                    .create()
                    .bind(toTable: self.table)
                    .customiseRow(forReuseIdentifier: "UserHistoryRowID", andHeight: 80) { (index, cell: UserHistoryRow, model: UserHistoryViewModel) in
                        cell.placement.text = model.getPlacement()
                        cell.date.text = model.getDate()
                    }
                    .clickRow(forReuseIdentifier: "UserHistoryRowID") { (index, model: UserHistoryViewModel) in
                        
                        self.performSegue("UserToCreatives")
                            .subscribe(onNext: { (dest: CreativesController) in
                                dest.placementId = model.getPlacementId()
                            })
                            .addDisposableTo(self.disposeBag)
                    }
                self.rxTable?.update(viewModels)
                
            })
            .addDisposableTo(disposeBag)
        
        // the touch gesture recogniser
        touch.rx.event.asObservable()
            .subscribe(onNext: { (event) in
                self.placementTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        rightBtn.rx.tap
            .subscribe(onNext: {
                LoginManager.sharedInstance.logout()
                self.dismiss(animated: true)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let s = subject {
            s.onNext(DbAux.getPlacementsFromHistory())
        }
    }
}
