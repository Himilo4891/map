

import Foundation

struct StudentLocation:Codable {
    
       let uniqueKey: String
       let firstName: String
       let lastName: String
       let mapString: String
       let mediaURL: String
       let latitude: Double
       let longitude: Double
    static var data = [StudentInformation]()
       

   }

