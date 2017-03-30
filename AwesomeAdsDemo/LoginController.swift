import UIKit
import RxCocoa
import RxSwift
import SAUtils

class LoginController: SABaseViewController {
    
    private let maxContraintHeight: CGFloat = 67.0
    private let minContraintHeight: CGFloat = 0.0
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    private var model: LoginModel = LoginModel.createEmpty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        loginButton.setTitle("page_login_button_login".localized, for: .normal)
        usernameField.placeholder = "page_login_textfield_user_placeholder".localized
        passwordField.placeholder = "page_login_textfield_password_placeholder".localized
        
        // whichever field starts, move the UI up
        Observable.of(usernameField.rx.controlEvent(.editingDidBegin), passwordField.rx.controlEvent(.editingDidBegin))
            .merge()
            .subscribe(onNext: {
                self.topContraint.constant = self.minContraintHeight
            })
            .addDisposableTo(disposeBag)
        
        usernameField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: {
                self.passwordField.becomeFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        // this checks to see if the user has inputed username + password
        // and updates the current model
        Observable.combineLatest(usernameField.rx.text.orEmpty, passwordField.rx.text.orEmpty) { username, password -> LoginModel in
                return LoginModel(username: username, password: password)
            }
            .do(onNext: { model in
                self.model = model
            })
            .map { model -> Bool in
                return model.isValid()
            }
            .subscribe(onNext: { isValid in
                self.loginButton.isEnabled = isValid
                self.loginButton.backgroundColor = isValid ? UIColorFromHex(0xED1C24) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // click on either the 
        Observable.of(loginButton.rx.tap, passwordField.rx.controlEvent(.editingDidEndOnExit))
            .merge()
            .do(onNext: {
                self.resignFields()
                SALoadScreen.getInstance().show()
            })
            .flatMap { Void -> Observable<LoginUser> in
                return LoginManager.sharedInstance.login(username: self.model.getUsername(), password: self.model.getPassword())
            }
            .subscribe(onNext: { loginUser in
                
                // stop this
                SALoadScreen.getInstance().hide()
                
                // if user is valid
                if (loginUser.isValid()) {
                    
                    // clear fields
                    self.clearFields()
                    self.clearModel()
                    
                    // save the user
                    LoginManager.sharedInstance.saveUser(user: loginUser)
                    
                    // set it for the current session
                    LoginManager.sharedInstance.setLoggedUser(user: loginUser)
                    
                    // go forward
                    self.performSegue("LoginToTabBar")
                }
                else {
                    self.authError()
                }
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func authError () {
        SAAlert.getInstance().show(withTitle: "page_login_popup_more_title".localized,
                                   andMessage: "page_login_popup_more_message".localized,
                                   andOKTitle: "page_login_popup_more_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default,
                                   andPressed: nil)
    }
    
    private func clearFields () {
        usernameField.text = ""
        passwordField.text = ""
    }
    
    private func clearModel () {
        model = LoginModel.createEmpty()
    }
    
    private func resignFields () {
        topContraint.constant = maxContraintHeight
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
