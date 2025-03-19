//
//  Person+CoreDataProperties.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?

}

extension Person : Identifiable {

}
