//
//  CoreDataStack.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    private init() {}
    
    static let myModel = "UserCoreDataModel"
    
    //Load the Model from the bundle
    lazy var managedObjedctModel: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: CoreDataStack.myModel, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    
    
    //Load the document directory URL
    lazy var documentDirectory: URL = {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        return docDirectory
    }()
    
    
    //Load the persistentstore container
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjedctModel)
        let persistentStoreURL = documentDirectory.appendingPathComponent("\(CoreDataStack.myModel).sqlite")
        do {
            try coordinator.addPersistentStore(type: .sqlite, at: persistentStoreURL)
        } catch {
            print("err in coordinator", error.localizedDescription)
        }
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.backgroundContext
        return context
    }()
    
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    
    
    func saveContext() {
        
        guard mainContext.hasChanges || backgroundContext.hasChanges else { return }
        
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch {
                print("Err in save the context", error.localizedDescription)
            }
        }
        
        backgroundContext.perform { [weak self] in
            do {
                try self?.backgroundContext.save()
            } catch {
                print("Err in save the context", error.localizedDescription)
            }
        }
    }
}
