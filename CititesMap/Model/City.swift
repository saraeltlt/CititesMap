//
//  City.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
// MARK: - city response
struct CityResponse: Codable {
    let country, name: String
    let id: Int
    let coord: Coord

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}

// MARK: - Coordinates
struct Coord: Codable {
    let lon: Double
    let lat: Double
}
