
import Foundation
struct LoginResponse: Codable {
    let account: Account
    let object: Session
    
}


struct Account: Codable {
    let register: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String
    let expiraton: String
}



    
