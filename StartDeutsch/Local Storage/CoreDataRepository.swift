//
//  CoreDataRepository.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/7/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import CoreData
import UIKit

class CoreDataRepository<RepositoryObject>: Repository where RepositoryObject: Entity, RepositoryObject.StoreType: NSManagedObject, RepositoryObject.StoreType.EntityObject == RepositoryObject {

    var persistentContainer: NSPersistentContainer{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }

    init() {
//        self.persistentContainer.loadPersistentStores { description, error in
//            if let error = error {
//                print("could not load store \(error.localizedDescription)")
//                return
//            }
//            print("store loaded")
//        }
    }
    
    func getAll(where predicate: NSPredicate?) throws -> [RepositoryObject]{
        let objects = try getManagedObjects(with: predicate)
        return objects.compactMap { $0.model }
    }

    func insert(item: RepositoryObject) {
        persistentContainer.viewContext.insert(item.toStorable(in: persistentContainer.viewContext))
        saveContext()
    }
    
    func update(item: RepositoryObject) throws {
        try delete(item: item)
        insert(item: item)
    }
    
    func delete(item: RepositoryObject) throws {
        let predicate = NSPredicate(format: "id == %@", item.id)
        let items = try getManagedObjects(with: predicate)
        persistentContainer.viewContext.delete(items.first!)
        saveContext()
    }
    
    private func getManagedObjects(with predicate: NSPredicate?) throws -> [RepositoryObject.StoreType] {
        let entityName = String(describing: RepositoryObject.StoreType.self)
        let request = NSFetchRequest<RepositoryObject.StoreType>(entityName: entityName)
        request.predicate = predicate
        
        return try persistentContainer.viewContext.fetch(request)
    }
    
    // MARK: - Core Data Saving support
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
