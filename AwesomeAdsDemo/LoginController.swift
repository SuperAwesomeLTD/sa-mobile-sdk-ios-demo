import UIKit
import RxCocoa
import RxSwift
import SuperAwesome

class LoginController: SABaseViewController {
    
    fileprivate let maxContraintHeight: CGFloat = 67.0
    fileprivate let minContraintHeight: CGFloat = 0.0
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var usernameField: SATextField!
    @IBOutlet weak var passwordField: SATextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    override func handle(_ state: AppState) {
        
        let loginState = state.loginState
        
        topContraint.constant = loginState.isEditing ? minContraintHeight : maxContraintHeight
        loginButton.isHidden = loginState.isLoading
        activityIndicator.isHidden = !loginState.isLoading

        if loginState.loginError {
            authError()
        }
        
        if loginState.jwtToken != nil {
            performSegue("LoginToLoad")
        }
    }
}

extension LoginController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        store?.dispatch(Event.EditLoginDetails)
    }
}

extension LoginController {
    
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
