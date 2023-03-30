


import Foundation


class UdacityAPI {
    
    
    
    
    
struct getStudentLocation: Codable {
        let refresh: String
        let StudentLocation: String
        let results: String
    }
    
struct PostStudentLocation: Codable {
        let uniqueKey: String
        let firstName: String
        let lastName: String
        let mapString: String
        let mediaURL: String
        let latitude: Float
        let longitude: Float
    }
struct UpdateLocationResponse: Codable {
        let updatedAt: String
    }
    

    
    struct UdacityErrorResponse: Codable, Error {
        let status: Int
        let message: String
    }
    
    struct ErrorResponse: Codable {
        
        let status: Int
        let error: String
    }
}
struct UserResponse: Codable, Hashable {
    
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        
    }
    
}

  
