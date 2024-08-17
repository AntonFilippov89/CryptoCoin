
import Foundation

class AuthViewModel {
    
    var login: String = ""
    var password: String = ""
    
    private let validLogin = "1234"
    private let validPassword = "1234"
    
    func validateCredentials() -> Bool {
        return login == validLogin && password == validPassword
    }
}
