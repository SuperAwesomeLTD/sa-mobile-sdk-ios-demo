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
    
    @IBAction func loginAction(_ sender: Any) {
        
        store?.dispatch(Event.LoadingJwtToken)
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        store?.dispatch(Event.loginUser(withUsername: username, andPassword: password))
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
    
    override func handle(_ state: AppState) {
        
        guard let loginState = state.loginState else {
            SALoadScreen.getInstance().hide()
            authError()
            return
        }
        
        if loginState.isLoading {
            SALoadScreen.getInstance().show()
        } else {
            SALoadScreen.getInstance().hide()
        }
        
        if loginState.jwtToken != nil {
            performSegue("LoginToLoad")
        }
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
