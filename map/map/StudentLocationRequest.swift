//
//  response.swift
//  map
//
//  Created by abdiqani on 02/02/23.
//

import Foundation

struct StudentLocationRequest:Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let results: String
    let objectId: String
    let data: Data
}
