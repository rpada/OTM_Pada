//
//  Locations.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation

struct Locations: Codable {
    
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var latitude: Double
    var longitude: Double
    
}
struct Results: Codable {
    let results: [Locations]
}

