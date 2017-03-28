import UIKit
import RxCocoa
import RxSwift
import SAUtils

class LoginController: SABaseViewController {
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    private var model: LoginModel = LoginModel.createEmpty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        loginButton.setTitle("page_login_button_login".localized, for: .normal)
        usernameField.placeholder = "page_login_textfield_user_placeholder".localized
        passwordField.placeholder = "page_login_textfield_password_placeholder".localized
       
        // this checks to see if the user has inputed username + password
        // and updates the current model
        Observable.combineLatest(usernameField.rx.text.orEmpty, passwordField.rx.text.orEmpty) { (username, password) -> LoginModel in
                return LoginModel(username: username, password: password)
            }
            .do(onNext: { (model) in
                self.model = model
            })
            .map { (model) -> Bool in
                return model.isValid()
            }
            .subscribe(onNext: { (isValid) in
                self.loginButton.isEnabled = isValid
                self.loginButton.backgroundColor = isValid ? UIColorFromHex(0xED1C24) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // every button tap there's a network request to see if the user
        // is correctly auth-ed and, if that's the case,
        // move forward
        loginButton.rx.tap
            .do(onNext: { (Void) in
                SALoadScreen.getInstance().show()
            })
            .flatMap { (Void) -> Observable<LoginUser> in
                return LoginManager.sharedInstance.login(username: self.model.getUsername(), password: self.model.getPassword())
            }
            .subscribe(onNext: { (loginUser) in
            
                // stop this
                SALoadScreen.getInstance().hide()
                
                // if user is valid
                if (loginUser.isValid()) {
                    
                    // save the user
                    LoginManager.sharedInstance.saveUser(user: loginUser)
                    
                    // set it for the current session
                    LoginManager.sharedInstance.setLoggedUser(user: loginUser)
                    
                    // go forward
                    self.performSegue(withIdentifier: "LoginToTabBar", sender: self)
                }
                else {
                    self.authError()
                }
                
            })
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}
