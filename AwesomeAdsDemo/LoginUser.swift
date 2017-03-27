
import UIKit

class LoginUser: NSObject {
    
    private var token: String?
    private var metadata: LoginMetadata?
    
    override init() {
        super.init()
    }
    
    convenience init (jsonData: Data) {
        let jsonString = String(data: jsonData, encoding: .utf8)
        self.init (jsonString: jsonString)
    }
    
    init (jsonString: String?) {
        super.init()
        if let json = jsonString,
           let data = json.data(using: .utf8),
           let dict = convertToDictionary(data: data) {
           
            if let token = dict["token"] as? String {
                self.token = token
                self.metadata = LoginMetadata.proessMetadata(oAuthToken: token)
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
            "token": token ?? "",
            "metadata": metadata?.dictionaryRepresentation() ?? ""
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
        if let metadata = metadata {
            return metadata.isValid()
        }
        return false
    }
    
    func getToken () -> String {
        if let token = token {
            return token
        }
        return ""
    }
}
