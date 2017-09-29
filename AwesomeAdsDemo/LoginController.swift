import UIKit
import RxCocoa
import RxSwift
import SAUtils

class LoginController: SABaseViewController {
    
    fileprivate let maxContraintHeight: CGFloat = 67.0
    fileprivate let minContraintHeight: CGFloat = 0.0
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var usernameField: SATextField!
    @IBOutlet weak var passwordField: SATextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitle("page_login_button_login".localized, for: .normal)
        usernameField.placeholder = "page_login_textfield_user_placeholder".localized
        passwordField.placeholder = "page_login_textfield_password_placeholder".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store?.addListener(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store?.removeListener(self)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        store?.dispatch(GetJwtTokenEvent())
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        store?.dispatch{ () -> Observable<Event> in
            loginUserAction(withUsername: username, andPassword: password)
        }
    }
    
    fileprivate func authError () {
        SAAlert.getInstance().show(withTitle: "page_login_popup_more_title".localized,
                                   andMessage: "page_login_popup_more_message".localized,
                                   andOKTitle: "page_login_popup_more_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .default,
                                   andPressed: nil)
    }
}

extension LoginController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.topContraint.constant = self.minContraintHeight
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.topContraint.constant = self.maxContraintHeight
    }
}

extension LoginController: HandlesStateUpdates {
    
    func handle(_ state: AppState) {
        
        if state.loginState.isLoading {
            SALoadScreen.getInstance().show()
        } else {
            SALoadScreen.getInstance().hide()
        }
        
        if state.loginState.error != nil {
            authError()
        }
        
        if state.loginState.jwtToken != nil {
            performSegue("LoginToMain")
        }
    }
}
