//
//  LocalCity+CoreDataProperties.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//
//

import Foundation
import CoreData


extension LocalCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalCity> {
        return NSFetchRequest<LocalCity>(entityName: "LocalCity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var image: Data?
    @NSManaged public var insertionOrder: Date?

}

extension LocalCity : Identifiable {

}
