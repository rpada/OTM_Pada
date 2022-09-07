//
//  RequestTokenResponse.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/2/22.
//

import Foundation

struct Session: Codable {
    let id: String
    let expiration: String
}

struct RequestTokenResponse: Codable {
    //let account: Account
    let session: Session
    
}
