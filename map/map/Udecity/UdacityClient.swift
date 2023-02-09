
import Foundation

class UdacityClient {
    
    struct Auth {
        static var objectId = ""
        static var uniqueKey = ""
    }
    
    struct UserInfo {
        static var firstName = ""
        static var lastName = ""
    }
    
    
    enum SortStudentLocation{
        case limit(by: String)
        case skip(limit: String, skipBy: String)
        case order(by: String)
        case uniqueKey(id: String)
        case limitAndOrder(limit: String, order:String)
    }
    
    
    enum SecurityType {
        case encodedResponse
        case noEncodedResponse
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case session
        case getUserData
        case updateLocation
        case createNewLocation
        case getStudentsLocation(by: SortStudentLocation)
        case signUp
        
        var stringURL: String {
            switch self {
            case .session:
                return Endpoints.base + "session"
            case .getUserData:
                return Endpoints.base + "users/\(Auth.uniqueKey)"
            case .updateLocation:
                return Endpoints.base + "StudentLocation/\(Auth.objectId)"
            case .createNewLocation:
                return Endpoints.base + "StudentLocation"
            case let .getStudentsLocation(by):
                switch by {
                case let .limit(by):
                    return Endpoints.base + "StudentLocation" + "?limit=\(by)"
                case let .skip(limit, skipBy):
                    return Endpoints.base + "StudentLocation" + "?limit=\(limit)" + "&skip=\(skipBy))"
                case let .order(by):
                    return Endpoints.base + "StudentLocation" + "?order=\(by)updatedAt"
                case let .uniqueKey(id):
                    return Endpoints.base + "StudentLocation" + "?uniqueKey=\(id)"
                case let .limitAndOrder(limit, order):
                    return Endpoints.base + "StudentLocation" + "?limit=\(limit)" + "&order=\(order)updatedAt"
                }
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringURL)!
        }
        
    }
    
    class func removeSecurityChars(_ data: Data, type: SecurityType) -> Data{
        
        switch type {
        case .encodedResponse:
            let range = 5..<data.count
            let data = data.subdata(in: range)
            return data
        case .noEncodedResponse:
            return data
        }
    }
    
    class func sendPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, response:ResponseType.Type, secureType: SecurityType, completionHandler: @escaping (ResponseType?, Error?)-> Void ){
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        do{
            request.httpBody = try encoder.encode(body)
        }
        catch {
            completionHandler(nil, error)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            let checkedData = removeSecurityChars(data, type: secureType)
            
            do {
                let responseAPI = try decoder.decode(ResponseType.self, from: checkedData)
                DispatchQueue.main.async {
                    completionHandler(responseAPI, nil)
                }
            }
            catch {
                do {
                    let responseError = try decoder.decode(UdacityErrorResponse.self, from: checkedData)
                    DispatchQueue.main.async {
                        completionHandler(nil, responseError)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    //MARK: - sendGETRequest: Send GET Request of Generic Type
    class func sendGETRequest<ResponseType:Decodable>(url: URL, response: ResponseType.Type, secureType: SecurityType, completionHandler: @escaping(ResponseType?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            let checkedData = removeSecurityChars(data, type: secureType)
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: checkedData)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
        
    }
    
    class func login(Email: String,Password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        let body = LoginRequest(udacity: Udacity(Email: Email, Password: Password))
        sendPOSTRequest(url: UdacityClient.Endpoints.session.url, body: body, response: Login.self, secureType: .encodedResponse) { (response, error) in
            if let response = response {
                Auth.uniqueKey = response.account.key
                completionHandler(true,nil)
            } else {
                completionHandler(false,error)
            }
        }
    }
    
    class func logout(completionHandler: @escaping (Error?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
        
            
            
            
            
            
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    Auth.uniqueKey = ""
                    Auth.objectId = ""
                    UserInfo.firstName = ""
                    UserInfo.lastName = ""
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
        }
        task.resume()
    }
    
    class func updateLocation(mapString: String, mediaURL: String, coordinates:(latitude:Double,longitude:Double), completionHandler: @escaping (Bool,Error?) -> Void ){
        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = StudentLocation(uniqueKey: Auth.uniqueKey, firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: mapString, mediaURL: mediaURL, latitude: coordinates.latitude, longitude: coordinates.longitude)
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completionHandler(true, nil)
                    }
                }else {
                    completionHandler(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func getUserData(completionHandler: @escaping (Bool, Error?)-> Void){
        sendGETRequest(url: Endpoints.getUserData.url, response: UserDataResponse.self, secureType: .encodedResponse) { (response, error) in
            if let response = response {
                UserInfo.firstName = response.firstName
                UserInfo.lastName = response.lastName
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func createStudentLocation(mapString: String, mediaURL: String, coordinates:(latitude:Double,longitude:Double) , completionHandler: @escaping (Bool, Error?) -> Void){
           
        let body = StudentLocation(uniqueKey: Auth.uniqueKey, firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: mapString, mediaURL: mediaURL, latitude: coordinates.latitude, longitude: coordinates.longitude)

           sendPOSTRequest(url: Endpoints.createNewLocation.url, body: body, response: StudentInformation.self, secureType: .noEncodedResponse) { (response, error) in
               if let response = response {
                   Auth.objectId = response.objectId
                   completionHandler(true, nil)
               }else {
                   completionHandler(false, error)
               }
           }
    }
    
    class func getStudentsLocationData(completionHandler: @escaping ([StudentInformation], Error?) -> Void) {
        sendGETRequest(url: Endpoints.getStudentsLocation(by: .limitAndOrder(limit: "100", order: "-")).url, response: StudentLocation.self, secureType: .noEncodedResponse) { (response, error) in
            if response != nil {
            }else {
                completionHandler([], error)
            }
        }
    }
    
}
