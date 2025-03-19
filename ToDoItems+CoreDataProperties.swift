//
//  ToDoItems+CoreDataProperties.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//
//

import Foundation
import CoreData


extension ToDoItems {

    @nonobjc public class func fetchRequest(filterPredicate: NSPredicate?) -> NSFetchRequest<ToDoItems> {
        let fetchRequest = NSFetchRequest<ToDoItems>(entityName: "ToDoItems")
        
        if let filterPredicate = filterPredicate {
            fetchRequest.predicate = filterPredicate
        }
        
        return fetchRequest
    }

    @NSManaged public var itemAddedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var itemType: ItemType?

}

extension ToDoItems : Identifiable {

}
