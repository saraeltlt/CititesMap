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
        return (city.coord.lat,city.coord.lon)
    }
    
}
