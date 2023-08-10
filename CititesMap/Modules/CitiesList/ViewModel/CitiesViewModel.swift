//
//  CitiesViewModel.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class CitiesViewModel {

   // MARK: - variables
    private let repository: CityRepository
    private var citiesArray = [City]()
   // private var toFilterArray = [City]()
    private var filteredArray = [City]()
    var isSearching: Bool = false
    private let networkMonitor = NetworkMonitor.shared
    let bindCities = Observable(false)
    let bindError = Observable<Error?>(nil)
    let bindSearch = Observable(false)
    
    init(repository: CityRepository) {
        self.repository = repository
    }

    // MARK: - Fetch cities from API and save locally
    func fetchCities() {
        bindCities.value = false
        repository.fetchCities() { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let cities):
                self.citiesArray = cities
                self.bindCities.value = true

            case .failure(let error):
                self.bindError.value = error
                self.bindCities.value = false
            }
        }
    }
    
   /* func getLocalCities() {
        repository.fetchCitiesLocal { result in
            switch result {
            case .success(let cities):
                self.toFilterArray = cities
            case .failure(let error):
                self.bindError.value = error
                self.toFilterArray = []
            }
        }
    }*/
    // MARK: - Filter Cities
    func filterCities(with searchText: String) {
        if searchText.isEmpty {
             isSearching = false
            filteredArray.removeAll()
         } else {
             isSearching = true
             filteredArray = citiesArray.filter { $0.name.lowercased().contains(searchText.lowercased()) }
             print ("ANA KEDA 3andy \(filteredArray.count)")
         }
        self.bindCities.value = true
    }

    // MARK: - Get city data
    func getCitiesCount() -> Int {
        if isSearching {
            return filteredArray.count
        } else {
            return citiesArray.count
        }
    }

    func getCityNameAndImage(index: Int) -> (String,Data?) {
        var city: City
        if isSearching {
            city = filteredArray[index]
        } else {
            city = citiesArray[index]
        }
        let cityName = "\(city.country), \(city.name)"
        let cityMapImage = city.image
        return (cityName, cityMapImage)
    }

    // MARK: - Navigate to map view
    func navigateToMap(index: Int) -> CityMapViewModel? {
        var city: City
        if isSearching {
            city = filteredArray[index]
        } else {
            city = citiesArray[index]
        }
        return CityMapViewModel(city: city)
    }
    
    // MARK: - Get network Status
    func isNetworkConnected() -> Bool {
       return networkMonitor.isConnected
    }
}
