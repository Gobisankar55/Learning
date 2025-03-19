//
//  CustomMigration.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//

import CoreData

class ItemTypeMigration: NSEntityMigrationPolicy  {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        //create lookup for item type
        var instanceType: NSManagedObject!
        
        let itemType = sInstance.value(forKey: "type") as! String
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemType")
        fetchRequest.predicate = NSPredicate(format: "name == %@", itemType)
        let results = try manager.destinationContext.fetch(fetchRequest)
        
        if let resultObj = results.last as? NSManagedObject {
            instanceType = resultObj
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "ItemType", in: manager.destinationContext)
            instanceType = NSManagedObject(entity: entity!, insertInto: manager.destinationContext)
            instanceType.setValue(itemType, forKey: "name")
        }
        
        
        //get the destination type
        let destResults = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
        if let lastDestination = destResults.last {
            lastDestination.setValue(instanceType, forKey: "type")
        }
    }
}
