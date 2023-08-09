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
    
    init(remoteDataSource: RemoteSourceProtocol, localDataSource: LocalSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        networkMonitor.startMonitoring { isConnected in
            self.networkIsConnected = isConnected
        }
    }
    
    func fetchCities(page: Int = 0,completion: @escaping (Result<[City], Error>) -> Void) {
        if networkIsConnected {
            print("YESSS internet connected")
                remoteDataSource.fetchAPICities(page: page, completion: completion)
            } else {
                print("NOO internet NOT connected")
                localDataSource.fetchCities(completion: completion)
            }
        }
    
    
    
    
}
