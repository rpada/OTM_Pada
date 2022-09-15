//
//  UpdatedLocation.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/8/22.
//

import Foundation

struct UpdatedLocation: Codable {
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let objectId: String
    let uniqueKey: String?
    let latitude: Double?
    let longitude: Double?
}
