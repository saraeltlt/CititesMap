//
//  CitiesViewModel.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class CitiesViewModel {
    private var cities = [City]()
    var bindCities:Observable<Bool>=Observable(false)
    
    
    func navigateToMap(index: Int) -> CityMapViewModel? {
       let city = City(country: "DE", name: "Karlsruhe", id: 2892794, coord: Coord(lon: 8.38583, lat: 49.004719))
        return CityMapViewModel(city: city)
        
       /* if cities.isEmpty {
            return nil
        } else {
            let city = cities[index]
            return CityMapViewModel(city: city)
        } */
    }
}
