//
//  login request.swift
//  map
//
//  Created by abdiqani on 02/02/23.
//

import Foundation

struct UdacityRequestType: Codable {
    var udacity: AuthenticationRequestType
}

struct AuthenticationRequestType: Codable {
    var Email: String
    var Password: String
}
