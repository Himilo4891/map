//
//  API.swift
//  map
//
//  Created by abdiqani on 02/02/23.
//



import Foundation


class API {
    
    static let shared = API()
    
    struct Auth {
        static var sessionId: String?
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
            case studentLocation
            case getRequestToken
            case postLocation
        
        var urlValue: String {
            switch self {
            case.studentLocation:
                return Endpoints.base + "/StudentLocation"
            case.getRequestToken:
                return Endpoints.base + "/session"
            case.postLocation:
                return Endpoints.base + "/objectID"
            }
        }
        var url: URL {
            return URL(string: urlValue)!
        }
    }
    
    class func postAuthenticateRequest() {
        var request = URLRequest(url: Endpoints.getRequestToken.url)
        request.httpMethod = "Post"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func postStudentLocation() {
        var request = URLRequest(url: Endpoints.studentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Daniel\", \"lastName\": \"Dickinson\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func putStudentLocation() {
        var request = URLRequest(url: Endpoints.postLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jenny\", \"lastName\": \"Dickinson\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    //Class func gets auth token from API for login.
    class func getRequestToken (completion: @escaping(Bool, Error?) -> ()) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { data, response, error in
            guard let data = data else {
                print("data was nil")
                return
            }
            //decode
            let decoder = JSONDecoder()
            do{
                let responseObject = try
                    decoder.decode(Login.self, from: data)
                completion(true, nil)
                Auth.sessionId = responseObject.session.id
            }catch {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    
    //Class function GET student data from API and decodes it in stuct format
    class func fetchLocationResults (completion: @escaping([StuData]) -> ()) {
        //let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"
        //let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: Endpoints.studentLocation.url) { data, response, error in
            
            guard let data = data else {
                print("data was nil")
                return
            }
            //decode
            guard let decodedData = try? JSONDecoder().decode(LocationResults.self, from: data) else {
                print("couldnt decode jsono")
                return
            }
            print(decodedData.results)
            completion(decodedData.results)
        }
        task.resume()
    }
}



struct LocationResults: Codable {
    let results: [StuData]
}

struct StuData: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

struct PostStudentLocation: Codable {
    var createdAt: String
    var objectId: String
}

struct PutStudentLocation: Codable {
    var updateAt: String
}

struct Login: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
struct UdacityErrorResponse: Codable, Error {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "error"
    }
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
struct UserDataResponse: Codable {
    
    let firstName: String
    let lastName: String
    let bio: String?
    let registered: Bool
    let linkedIn: String?
    let location: String?
    let key: String
    let imageUrl: String?
    let nickname: String?
    let website: String?
    let occupation: String?
    
    enum CodingKeys: String, CodingKey {
        case bio
        case registered = "_registered"
        case linkedIn = "linkedin_url"
        case imageUrl = "_image_url"
        case key
        case location
        case nickname
        case website = "website_url"
        case occupation
        case firstName = "first_name"
        case lastName = "last_name"
    }

}
struct StudentInformation: Codable {
    
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
    let results: String
    let data: Data
}


