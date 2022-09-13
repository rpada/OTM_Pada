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
        case newLocation
        case studentLocations
        var urlValue: String {
            switch self {
            case .newLocation:
                return Endpoints.base + "/StudentLocation"
            case .studentLocations: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            }
        }
        
        var url: URL { return URL(string: urlValue)! }
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
    
    // https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/6acdc289-de30-4f0e-b408-626668c70629
    class func getStudentLocations(completion: @escaping ([Locations]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationData.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
}
    
    //taskForPOSTRequest function is from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/cd890113-636f-474a-8558-8b1a5e633c77/concepts/70ad5b51-cdcf-43d5-97fa-5ee5fe4c7601
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
          var request = URLRequest(url:url)
          request.httpMethod = "POST"
          request.httpBody = try!
          JSONEncoder().encode(body)
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 guard let data = data else {
                     DispatchQueue.main.async {
                         completion(nil, error)
                     }
                     return
                 }
                 let decoder = JSONDecoder()
                 do {
                     let responseObject = try
                     decoder.decode(ResponseType.self, from: data)
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
    // also from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/cd890113-636f-474a-8558-8b1a5e633c77/concepts/70ad5b51-cdcf-43d5-97fa-5ee5fe4c7601
    // and https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/cd890113-636f-474a-8558-8b1a5e633c77/concepts/cf2fca61-2751-4c2e-963e-f55af30c0204
    // Udacity mentor help https://knowledge.udacity.com/questions/897516
    class func addStudentLocation(information: Locations, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        DataClient.taskForPOSTRequest(url: Endpoints.newLocation.url, apiType: "Parse", responseType: PostedLocation.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                Auth.tokenRequest = response.objectId ?? ""
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            }
            completion(false, error)
        }
    }
}

