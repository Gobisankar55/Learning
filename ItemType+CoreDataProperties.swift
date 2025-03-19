//
//  ItemType+CoreDataProperties.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var name: String?
    @NSManaged public var toDoItem: ToDoItems?

}

extension ItemType : Identifiable {

}
