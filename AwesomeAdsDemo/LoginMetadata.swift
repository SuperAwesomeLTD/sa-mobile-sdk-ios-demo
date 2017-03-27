
import UIKit
import SAModelSpace

class LoginMetadata: NSObject {
    
    private var id: Int = 0
    private var username: String?
    private var email: String?
    private var iat: Int = 0
    private var exp: Int = 0
    private var iss: String?
    
    convenience init (jsonData: Data) {
        let jsonString = String(data: jsonData, encoding: .utf8)
        self.init (jsonString: jsonString)
    }
    
    init (jsonString: String?) {
        super.init()
        if let json = jsonString,
           let data = json.data(using: .utf8),
           let dict = convertToDictionary(data: data) {
            
            if let id = dict["id"] as? Int {
                self.id = id
            }
            if let username = dict["username"] as? String {
                self.username = username
            }
            if let email = dict["email"] as? String {
                self.email = email
            }
            if let iat = dict["iat"] as? Int {
                self.iat = iat
            }
            if let exp = dict["exp"] as? Int {
                self.exp = exp
            }
            if let iss = dict["iss"] as? String {
                self.iss = iss
            }
        }
    }
    
    func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }

    func dictionaryRepresentation() -> [String : Any] {
        return [
            "id": id,
            "username": username ?? "",
            "email": email ?? "",
            "exp": exp,
            "iat": iat,
            "iss": iss ?? ""
        ]
    }
    
    func stringRepresentation () -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionaryRepresentation(), options: .prettyPrinted)
            return String (data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func isValid () -> Bool {
        let now = NSDate().timeIntervalSince1970
        return (now - TimeInterval(exp)) < 0
    }
    
    static func proessMetadata (oAuthToken: String?) -> LoginMetadata? {
        
        if let oAuthToken = oAuthToken {
            
            let subtokens: [String] = oAuthToken.components(separatedBy: ".")
            if subtokens.count >= 2 {
                let token0 = subtokens[1]
                let token1 = token0 + "="
                let token2 = token1 + "="
    
                let data0 = Data(base64Encoded: token0, options: .ignoreUnknownCharacters)
                let data1 = Data(base64Encoded: token1, options: .ignoreUnknownCharacters)
                let data2 = Data(base64Encoded: token2, options: .ignoreUnknownCharacters)
                
                if let d0 = data0 {
                    return LoginMetadata (jsonData: d0)
                }
                else if let d1 = data1 {
                    return LoginMetadata (jsonData: d1)
                }
                else if let d2 = data2 {
                    return LoginMetadata (jsonData: d2)
                }
            }
        }
        
        return nil
        
    }

}
