//
//  DataFromUsers.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation

struct DataFromUsers: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
