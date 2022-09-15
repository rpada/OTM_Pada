import Foundation
import MapKit

class UdacityClient {
    
    struct Auth {
        static var sessionId: String? = nil
        static var firstName = ""
        static var lastName = ""
        static var key = ""
        static var tokenRequest = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"

        case UdacityLogin
        case UdacityLogout
        case grabUserInfo
        var urlValue: String {
            switch self {
            case .UdacityLogin: return Endpoints.base + "session"
            case .UdacityLogout: return Endpoints.base + "session"
            case .grabUserInfo:
                return Endpoints.base + "/users/" + Auth.key
            }
        }
        
        var url: URL { return URL(string: urlValue)! }
    }
    // from Udacity API: POSTing a Session and Udacity Login: Login with Email And Password
    //https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/7f5f110b-8f78-413d-af65-db7dca09e338/concepts/bbf200f4-7992-4c36-b942-350a839af907
    //https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.UdacityLogin.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = ("{\"udacity\": {\"username\": \"" + email + "\", \"password\": \"" + password + "\"}}").data(using: .utf8)
       // let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: newData)
                Auth.key = responseObject.account.key
                Auth.tokenRequest = responseObject.session.id
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
}
    
    // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/7f5f110b-8f78-413d-af65-db7dca09e338/concepts/5d6dbe28-ca9d-48ad-98d3-3712a9cbb75b
    
    // https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/e3b146dd-c487-4915-8d91-7816fe67d243
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
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
            if error != nil {
                completion(false, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            completion(true, nil)
        }
        task.resume()
    }
    
    // adapted from udacity movie project: https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/cd890113-636f-474a-8558-8b1a5e633c77/concepts/b6181fb1-c0aa-4a35-9078-3f2e177075ac#
// https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/7f5f110b-8f78-413d-af65-db7dca09e338/concepts/4dceaf4e-8fa6-43a5-af5a-9ca7fdfd7c25
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
                  let task = URLSession.shared.dataTask(with: url) { data, response, error in
                      guard let data = data else {
                          DispatchQueue.main.async {
                              completion(nil, error)
                          }
                          return
                      }
                      //https://knowledge.udacity.com/questions/899643
                      let range = 5..<data.count
                      let newData = data.subdata(in: range)
                      let decoder = JSONDecoder()
                      do {
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
                  task.resume()
                   return task
               }
       class func grabUserInfo(completion: @escaping (Bool, Error?) -> Void) {
             taskForGETRequest(url: Endpoints.grabUserInfo.url, responseType: DataFromUsers.self) { (response, error) in
                 if let response = response {
                     Auth.firstName = response.firstName
                     Auth.lastName = response.lastName
                     // test
                     print("\(response.firstName)\(response.lastName)")
                     completion(true, nil)
                 } else {
                     // test
                     print("Error")
                     completion(false, error)
                 }
             }
         }
}

