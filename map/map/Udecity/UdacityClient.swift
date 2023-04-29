
import Foundation

class UdacityClient {
    
    static var shared = UdacityClient()
    static var firstName = ""
    static var lastName = ""
    
    struct User {
        static var firstName = ""
        static var lastName = ""
        static var createdAt = ""
        static var location = ""
        static var url = ""
        static var updatedAt = ""
    }
    
    struct PreviousPostLocationObject {
        static var objectId = ""
        }
    
    struct Auth {
        static var objectId = ""
        static var accountKey = ""
    }
    
enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/"
    
        case session
        case getUserData
        case updateLocation
        case createNewLocation
        case postStudentLocation
        case StudentLocation
        case logout
        case webAuth
        case login
        
        var stringURL: String {
            switch self {
            case .login:
                return "https://onthemap-api.udacity.com/v1/session"

            case .session:
                return  "https://onthemap-api.udacity.com/v1/session"
            case .getUserData:
                return "/users/\(Auth.accountKey)"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/8ZExGR5uX8"
                
            case .postStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .StudentLocation:
                return Endpoints.base + "StudentLocation?limit=-100"
            case .logout: return "https://onthemap-api.udacity.com/v1/session"
            case .webAuth: return "https://auth.udacity.com/sign-up"
            case .createNewLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"

            }
        }
        
        var url: URL {
            return URL(string: stringURL)!
        }
        
    }
    
//      ff  class func removeSecurityChars(_ data: Data, type: SecurityType) -> Data{
//
//            switch type {
//            case .encodedResponse:
//                let range = 5..<data.count
//                let data = data.subdata(in: range)
//                return data
//            case .noEncodedResponse:
//                return data
//            }
//        }
    class func sendGETRequest<ResponseType: Decodable>(url: URL, responseType : ResponseType.Type,completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject,nil)
                }
            } catch {
                
                do {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func sendPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url:URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void ){
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
            }
            
        }
        task.resume()
    }
    
    class func login(Email: String,Password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = ("{\"udacity\": {\"username\": \"" + Email + "\", \"password\": \"" + Password + "\"}}").data(using: .utf8)
        let session = URLSession.shared;
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
                return
            }
            
            do{
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                
                DispatchQueue.main.async {
                    Auth.accountKey = responseObject.account.key!
                    Auth.objectId = responseObject.session.id
                    completionHandler(responseObject.account.registered!, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
            
        }
        task.resume()
    }
      
    class func logout(completionHandler: @escaping (Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(false as? Error)
                }
                return
            }
            
            do{
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                DispatchQueue.main.async {
                    Auth.objectId = ""
                    completionHandler(true as? Error)
                }
             
            }catch{
                completionHandler(false as? Error)
                print("Logout failed.")
            }
           
        }
        
        task.resume()
    }


    
    class func getStudentsLocation(completion : @escaping([StudentLocation], Error? ) -> Void){
        sendGETRequest(url: Endpoints.StudentLocation.url, responseType: StudentLocationResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
                print(response)
                
            } else {
                completion([], error)
            }
        }
    }
    
  class func getUserData(completion: @escaping (String?, String?, Error?) -> Void) {
       sendGETRequest(url: Endpoints.getUserData.url, responseType: UserDataResponse.self) { response, error in
            if let response = response{
                completion(response.firstName, response.lastName, nil)
                print("getting user data completed")
                User.firstName = response.firstName
                User.lastName = response.lastName
            } else {
                completion(nil, nil, error)
            }
        }
    }

    class func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion: @escaping (Bool, Error?) -> Void) {
        let body = PostLocationRequest(uniqueKey: Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        sendPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostingStudentLocationResponse.self, body: body) { response, ErrorMessage in

            if let response = response {
                User.createdAt = response.createdAt
                PreviousPostLocationObject.objectId = response.objectId
                completion(true, nil)
            } else {
                
            completion(false, ErrorMessage)
            }
        }
        
        
    }
    
    
    class func updateStudentsLocations(firstName : String, lastName : String, mapString : String, mediaURL : String, longitude : Double, latitude : Double, completion : @escaping(Bool, Error?) -> Void) {
        
        
        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = PostLocationRequest(uniqueKey: Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: Float(latitude), longitude: Float(longitude))
    
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(puttinStudentLocation.self, from: data)
                User.updatedAt = responseObject.updatedAt
            } catch  {
                do {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    let responseObject = try JSONDecoder().decode(puttinStudentLocation.self, from: newData)
                    DispatchQueue.main.async {
                        User.updatedAt = responseObject.updatedAt
                        print("location updated")
                        completion(true, nil)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
        
    }
    
