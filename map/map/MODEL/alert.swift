//
//
//import Foundation
//
//class AlertNotification{
//    
//    struct Titles {
//        let ofController: String
//        let ofAction: String
//    }
//    
//    enum ofType {
//        case loginFailed
//        case retrieveUserDataFailed
//        case retrieveUsersLocationFailed
//        case incorrectURLFormat
//        case emptyFields
//        case incorrectGeoLocation
//        case createLocationFailed
//
//        var getTitles: Titles{
//            switch self {
//            case .loginFailed:
//                return Titles(ofController: "Login Failed", ofAction: "Ok")
//            case .retrieveUserDataFailed:
//                return Titles(ofController: "Get User Info Failed", ofAction: "Ok")
//            case .retrieveUsersLocationFailed:
//                return Titles(ofController: "Get Users Location Failed", ofAction: "Ok")
//            case .incorrectURLFormat:
//                return Titles(ofController: "Failed to open URL", ofAction: "Ok")
//            case .emptyFields:
//                return Titles(ofController: "Empty Fields", ofAction: "Ok")
//            case .incorrectGeoLocation:
//                return Titles(ofController: "Invalid Location", ofAction: "Ok")
//            case .createLocationFailed:
//                return Titles(ofController: "Submission failed", ofAction: "Ok")
//            }
//        }
//    }
//}
//
