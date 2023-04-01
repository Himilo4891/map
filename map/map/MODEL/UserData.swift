//
//  UserData.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/4/21.
//

import Foundation

struct UserDataResponse: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
