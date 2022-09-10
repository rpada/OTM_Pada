//
//  Locations.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation

struct Locations: Codable {
    
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.objectId = dictionary["objectId"] as? String
    }
}
struct Results: Codable {
    let results: [Locations]
}
