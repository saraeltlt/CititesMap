//
//  CitiesViewModel.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class CitiesViewModel {
    private let repository: CityRepository
    var citiesArray = [City]()
    let bindCities = Observable(false)
    let bindError = Observable<Error?>(nil)
    var currentPage = 1
    
    init(repository: CityRepository) {
        self.repository = repository
    }
    
    func fetchCities() {
        bindCities.value = false
        repository.fetchCities(page: currentPage) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let cities):
                self.currentPage = self.currentPage+1
                self.bindCities.value = true
                self.citiesArray = self.citiesArray + cities
            case .failure(let error):
                print("Error fetching cities: \(error)")
                self.bindError.value = error
                self.bindCities.value = false
            }
        }
    }
    
    
    func navigateToMap(index: Int) -> CityMapViewModel? {
        print ("fehhaa \(citiesArray.count)")
        if citiesArray.isEmpty {
            return nil
        } else {
            let city = citiesArray[index]
            return CityMapViewModel(city: city)
        }
    }
    
    func getCitiesCount() -> Int {
        return citiesArray.count
    }
    func getCityName(index: Int) -> String {
       return "\(citiesArray[index].country), \(citiesArray[index].name)"
    }
    
    func getCityImage(index: Int, completion: @escaping ((Data?) -> Void)) {
        let x = RemoteSource()
        
        x.staticMapURL(latitude: Double(citiesArray[index].coord.lat) ?? 0.0,
                       longitude: Double(citiesArray[index].coord.lon) ?? 0.0) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("ERRORRRR \(error)")
                completion(nil)
            }
        }
    }

}
