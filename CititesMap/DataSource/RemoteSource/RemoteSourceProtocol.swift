//
//  RemoteSourceProtocol.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
protocol RemoteSourceProtocol {
    func fetchAPICities(page: Int, completion: @escaping (Result<[City], Error>) -> Void)
    func staticMapURL(latitude: Double, longitude: Double, completion: @escaping (Result<Data, Error>) -> Void)
}
