
import Foundation
struct ResultsResponse: Codable {
    let results : [StudentInformation]
    
}
    
    
    struct StudentInformation: Codable {
        static var lastFetched: [PostStudentLocation]?
        
        let firstName: String
        let lastName: String
        let longitude: Double
        let latitude: Double
        let mapString: String
        let mediaURL: String
        let uniqueKey: String
        let objectId: String
        let createdAt: String
        let updatedAt: String
        let locationId: String
        
    
        
        init( createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, locationId: String, uniqueKey: String, updatedAt: String) {
            self.createdAt = createdAt
            self.firstName = firstName
            self.lastName = lastName
            self.latitude = latitude
            self.longitude = longitude
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.objectId = objectId
            self.locationId = locationId
            self.uniqueKey = uniqueKey
            self.updatedAt = updatedAt
            
        
        
        
    }
}
