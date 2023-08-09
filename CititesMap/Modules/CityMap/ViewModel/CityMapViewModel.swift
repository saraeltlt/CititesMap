//
//  CityMapViewModel.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
class CityMapViewModel {
    private var city: City
    var bindMap:Observable<Bool>=Observable(false)
    
    init(city: City){
        self.city = city
    }
    
    func getCityName() -> String {
        return "\(city.country), \(city.name)"
    }
    func getCityCoord() -> (Double,Double) {
        let lat = Double (city.coord.lat) ?? 0.0
        let lon = Double (city.coord.lon) ?? 0.0
        return (lat,lon)
    }
    
}
