import UIKit
import RxCocoa
import RxSwift

class LoginManager: NSObject {
    
    enum LoginManagerError: Error {
        case UserNotLogged
        case SessionExpired
    }
    
    static let sharedInstance: LoginManager = LoginManager ()
    private override init() {}
    
    private var loggedUser: LoginUser?
    
    func login (username: String, password: String) -> Observable <LoginUser> {
        return LoginService.login(username: username, password: password)
    }
    
    func logout () {
        loggedUser = nil
        UserDefaults.standard.set(loggedUser, forKey: "logedUser")
        UserDefaults.standard.synchronize()
    }
    
    func check () -> Observable<LoginUser> {
        return Observable.create({ (subscriber) -> Disposable in
            
            let data = UserDefaults.standard.object(forKey: "logedUser")
            
            if let data = data as? String {
                let user = LoginUser(jsonString: data)
                
                if user.isValid() {
                    subscriber.onNext(user)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(LoginManagerError.SessionExpired)
                }
            } else {
                subscriber.onError(LoginManagerError.UserNotLogged)
            }
            
            return Disposables.create()
        })
    }
    
    func setLoggedUser (user: LoginUser) {
        loggedUser = user
    }
    
    func getLoggedUserToken () -> String {
        if let user = loggedUser {
            return user.getToken()
        }
        return ""
    }

    func saveUser (user: LoginUser) {
        UserDefaults.standard.set(user.stringRepresentation(), forKey: "logedUser")
        UserDefaults.standard.synchronize()
    }
}
