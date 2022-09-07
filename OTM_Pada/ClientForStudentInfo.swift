//
//  ClientForStudentInfo.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation
class DataClient {
    
    struct Auth {
        static var firstName = ""
        static var lastName = ""
        static var key = ""
        static var tokenRequest = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"

        case studentLocations
        case postStudentLocation
        case putStudentLocation(String)
        case getPublicUserData(Int)
        var urlValue: String {
            switch self {
    
            case .studentLocations: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "StudentLocation/" + objectId
            case .getPublicUserData(let userId): return Endpoints.base + "users/\(userId)"
            }
        }
        
        var url: URL { return URL(string: urlValue)! }
    }
    // adapted from udacity movie project: https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/cd890113-636f-474a-8558-8b1a5e633c77/concepts/b6181fb1-c0aa-4a35-9078-3f2e177075ac#

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
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

    // https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/cd890113-636f-474a-8558-8b1a5e633c77/concepts/13238b1f-33b9-42a0-9597-6618a9168a33
    class func getStudentLocations(completion: @escaping ([Locations]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationData.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
}
}
