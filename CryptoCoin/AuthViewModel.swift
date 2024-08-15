
import Foundation

class AuthViewModel {
    var login: String = ""
    var password: String = ""
    let validLogin = "1234"
    let validPassword = "1234"
    
    func validateCredentials() -> Bool {
        return login == validLogin && password == validPassword
    }
}
