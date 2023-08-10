//
//  CityRepository.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class CityRepository: CityRepositoryProtocol {
    
    private let remoteDataSource: RemoteSourceProtocol
    private let localDataSource: LocalSourceProtocol
    private let networkMonitor = NetworkMonitor.shared
    private var networkIsConnected = false
    private var citiesArray = [City] ()
    private var currentPage = 0
    let dispatchGroup = DispatchGroup()
    init(remoteDataSource: RemoteSourceProtocol, localDataSource: LocalSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        networkMonitor.startMonitoring { isConnected in
            self.networkIsConnected = isConnected
        }
    }
    
    func fetchCities(completion: @escaping (Result<[City], Error>) -> Void) {
        if networkIsConnected {
            var range = currentPage*50
            currentPage+=1
            remoteDataSource.fetchAPICities(page: currentPage) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let cities):
                    self.citiesArray = self.citiesArray + cities
                     if range >= self.citiesArray.count {
                          range = 0
                     }
                    for i in range...(citiesArray.count - 1) {
                        dispatchGroup.enter()
                        self.getMapImage(index: i)
                    }
                    dispatchGroup.notify(queue: DispatchQueue.global()) {
                        print("All map image fetches completed.")
                        completion(.success(self.citiesArray))
                         self.cachCities(Array(self.citiesArray.suffix(from: range)))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            localDataSource.fetchCities(completion: completion)
        }
    }
    
    func cachCities(_ cities: [City]) {
        localDataSource.saveCities(cities) { (result: Result<Void, Error>) in
            switch result {
            case .success():
                print("Caching SUCCESSfULLY")
            case .failure(let error):
                print("Error caching cities: \(error)")
            }
            
        }
    }

    func getMapImage(index: Int) {
        remoteDataSource.staticMapURL(latitude: Double(citiesArray[index].coord.lat) ?? 0.0,
                                      longitude: Double(citiesArray[index].coord.lon) ?? 0.0) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.citiesArray[index].image = data
                dispatchGroup.leave()
            case .failure(_):
                self.citiesArray[index].image = nil
                dispatchGroup.leave()
            }
        }
    }
     func fetchCitiesLocal(completion: @escaping (Result<[City], Error>) -> Void) {
          localDataSource.fetchCities(completion: completion)
     }
}
