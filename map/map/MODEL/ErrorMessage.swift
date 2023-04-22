
import Foundation

struct ErrorMessage {
//    let status: Int
//    let error: String
    let message: String
}

extension ErrorMessage: LocalizedError {
    var errorDescription: String? {
//        return error
        return message
    }
}
