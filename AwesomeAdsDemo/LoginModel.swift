import UIKit

class LoginModel: NSObject {

    private var username: String?
    private var password: String?
    
    init (username: String?, password: String?) {
        super.init()
        self.username = username
        self.password = password
    }
    
    static func createEmpty () -> LoginModel {
        return LoginModel (username: nil, password: nil)
    }
    
    func isValid () -> Bool {
        if let u = username, let p = password, !u.isEmpty && !p.isEmpty {
            return true
        }
        return false
    }
    
    func getUsername () -> String {
        if let u = username {
            return u
        } else {
            return ""
        }
    }
    
    func getPassword () -> String {
        if let p = password {
            return p
        } else {
            return ""
        }
    }
}
