import UIKit
import SANetworking
import RxCocoa
import RxSwift

class LoginService: NSObject {

    private static func getEndpoint () -> String {
        return "https://api.dashboard.superawesome.tv/v2/user/login"
    }
    
    private static func getBody (username: String, password: String) -> [String : String] {
        return [
            "username": username,
            "password": password
        ]
    }
    
    private static func getQuery () -> [String : String] {
        return [:]
    }
    
    private static func getHeader () -> [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    static func login (username: String, password: String) -> Observable<LoginUser> {
        
        let endpoint = getEndpoint()
        let body = getBody(username: username, password: password)
        let query = getQuery()
        let header = getHeader()
    
        let network = SANetwork ()
        
        return Observable<LoginUser>.create { (subscriber) -> Disposable in
            
            network.sendPOST(endpoint, withQuery: query, andHeader: header, andBody: body) { (status, payload, success) in
                
                let loginUser = LoginUser(jsonString: payload)
                subscriber.onNext(loginUser)
                subscriber.onCompleted()
                
            }
            
            return Disposables.create()
        }
    }
    
}
