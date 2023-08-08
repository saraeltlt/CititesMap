//
//  RemoteSource.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class RemoteSource: RemoteSourceProtocol {

    func fetchAPICities(page: Int, completion: @escaping (Result<[CityResponse], Error>) -> Void) {
        let urlString = Constants.baseURL + String(page)
        print("MY URL \(urlString)")
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let cities = try JSONDecoder().decode([CityResponse].self, from: data)
                    completion(.success(cities))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
