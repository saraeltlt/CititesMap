//
//  RemoteSource.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class RemoteSource: RemoteSourceProtocol {

    func fetchAPICities(page: Int, completion: @escaping (Result<[City], Error>) -> Void) {
        let urlString = Constants.CitiesBaseURL + String(page)
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
                    let cities = try JSONDecoder().decode([City].self, from: data)
                    completion(.success(cities))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func staticMapURL(latitude: Double, longitude: Double) -> URL? {
        let urlString = "https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=12&size=100x100&key=\(Constants.mapsImageApiKey)"
        return URL(string: urlString)
    }

}
