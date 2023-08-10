//
//  LocalSourceProtocol.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation

protocol LocalSourceProtocol {
    func fetchCities(completion: @escaping (Result<[City], Error>) -> Void)
    func saveCities(_ cities: [City], completion: @escaping (Result<Void, Error>) -> Void)
}
