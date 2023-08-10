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
    let bindCities = Observable(false)
    let bindError = Observable<Error?>(nil)
    
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

    // MARK: - Get city data
    func getCitiesCount() -> Int {
        return citiesArray.count
    }

    func getCityNameAndImage(index: Int) -> (String,Data?) {
        let cityName = "\(citiesArray[index].country), \(citiesArray[index].name)"
        let cityMapImage = citiesArray[index].image
        return (cityName,cityMapImage)
    }

    // MARK: - Navigate to map view
    func navigateToMap(index: Int) -> CityMapViewModel? {
        if citiesArray.isEmpty {
            return nil
        } else {
            let city = citiesArray[index]
            return CityMapViewModel(city: city)
        }
    }
}
