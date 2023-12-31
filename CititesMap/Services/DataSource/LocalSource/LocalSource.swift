//
//  LocalSource.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//


import UIKit
import CoreData
class LocalSource: LocalSourceProtocol {
    // MARK: -signletoon object
    static let shared = LocalSource()
    private init () {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    // MARK: private variables
    private var context : NSManagedObjectContext
    
    // MARK: -get all cities from core data
    func fetchCities(completion: @escaping (Result<[City], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<LocalCity> = LocalCity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "insertionOrder", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let localCities = try context.fetch(fetchRequest)
            let cities = convertFromLocalCities(localCities)
            completion(.success(cities))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: -save all loaded cities to core data
    func saveCities(_ cities: [City], completion: @escaping (Result<Void, Error>) -> Void) {
        for city in cities {
            convertToLocalCities(city)
        }
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    // MARK: -helper conversion function
    private func convertFromLocalCities(_ cities: [LocalCity]) -> [City] {
        return cities.map { localCity in
            let coord = Coord(lon: localCity.lon ?? "", lat: localCity.lat ?? "")
            return City(
                country: localCity.country ?? "",
                name: localCity.name ?? "",
                id: localCity.id ?? "",
                coord: coord,
                image: localCity.image ?? Data()
            )
        }
    }
    
    private func convertToLocalCities(_ city: City) {
        let localCity = LocalCity(context: context)
        localCity.id = city.id
        localCity.name = city.name
        localCity.country = city.country
        localCity.lat = city.coord.lat
        localCity.lon = city.coord.lon
        localCity.image = city.image
        localCity.insertionOrder = Date()
    }
    
}
