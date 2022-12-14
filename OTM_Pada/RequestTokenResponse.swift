//
//  RequestTokenResponse.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/2/22.
//

// https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/6acdc289-de30-4f0e-b408-626668c70629
// https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/cf4383e9-66c5-4319-9502-3a486631d897
import Foundation

struct Session: Codable {
    let id: String
    let expiration: String
}
struct Account: Codable {
    let registered: Bool
    let key: String
}

struct RequestTokenResponse: Codable {
    let session: Session
    let account: Account
    
}
