//
//  PhotoID+CoreDataProperties.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 14/06/2021.
//
//

import Foundation
import CoreData


extension PhotoID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoID> {
        return NSFetchRequest<PhotoID>(entityName: "PhotoID")
    }

    @NSManaged public var id: String?

}

extension PhotoID : Identifiable {

}
