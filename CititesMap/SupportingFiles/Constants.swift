//
//  Constants.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit
struct Constants {
    struct EndPoint {
        private static let mapsImageApiKey = "AIzaSyBoa2g2CFiVhNSA-OreoL5tBEzNc5WLV-U"
        static let CitiesBaseURL = "http://assignment.pharos-solutions.de/cities.json?page="
        static let pageSize = 50
        static func getImageAPIEndpoint(lat: String, lon: String) -> String  {
            return "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(lon)&zoom=10&size=120x120&markers=color:red&key=\(mapsImageApiKey)"
        }
    }

    struct Images {
        static let globeImage = UIImage(named: "img_globe")
        static let noConnectionImage = UIImage(named: "img_noConnection")
        static let noSearchImage = UIImage(named: "img_noSearchResult")
    }
    
    struct keyWords {
        static let appName = "Cities Guru"
        static let noConnection = "No internet Connection \n please try again"
        static let invalidURL = "Invalid URL"
        static let noMoreCached = "No more cached data to show \n please check your connection"
        static let noMoreSearchResult = "No more loaded cities \n with this search value"
    }
    
    struct Identifiers {
        static let cityCell = "CityCell"
        static let CitiesListStroyBoard = "CitiesList"
        static let CityMapStroyBoard = "CityMap"
        static let CitiesVC = "CitiesViewController"
        static let cityMapVC = "CityMapViewController"
    }
    
    struct Dimentions {
        static let fontSize = 20.0
        static let logoHeight = 44.0
        static let logoWidth = Constants.Dimentions.logoHeight*2
        static let logoFrame = CGRect(x: 0.0, y: 0.0,
                                      width: Constants.Dimentions.logoWidth,
                                      height: Constants.Dimentions.logoHeight)
        static let font = UIFont(name: "MarkerFelt-Wide", size: Constants.Dimentions.fontSize)!
    }
    

}
