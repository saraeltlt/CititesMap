//
//  LocalSource.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class LocalSource: LocalSourceProtocol {
    func fetchCities(completion: @escaping (Result<[City], Error>) -> Void) {
        print("fetch")
        // Implement Core Data fetching here
    }
    
    func saveCities(_ cities: [City], completion: @escaping (Result<Void, Error>) -> Void) {
        print("save")
        // Implement Core Data saving here
    }
    
    
}
