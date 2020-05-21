//
//  CoreDataRepository.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/7/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import CoreData
import UIKit
import Combine

protocol Repository {
    func getAll<T: Entity>(where parameters: Dictionary<String, Any>?) -> Future<[T], Error>
    func insert<T: Entity>(item: T)
    func delete<T: Entity>(item: T)
}

class CoreDataRepository<T>: Repository where T: Entity, T.StoreType: NSManagedObject, T.StoreType.EntityObject == T {

    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer){
        self.persistentContainer = container
    }
    
    convenience init() {
        // Use the default container for production environment.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Can not get shared app delegate")
            fatalError()
        }
        self.init(container: appDelegate.persistentContainer)
    }

    /// In case of success returns array of existing models againt given query, in case of failure returns error.
    /// - Parameters:
    ///   - parameters: Optional Dictionary<String, Any> containing query. Ex: ["courseId":"id1"].
    /// - Returns: Future<[T], Error> where T is conformable to Entity protocol, meaning it has associated ManagedObject.
    func getAll<T>(where parameters: Dictionary<String, Any>?) -> Future<[T], Error> where T : Entity {
        return Future<[T], Error>{ promise in
            do {
                // TODO: Fix force casting to String
                let predicate = parameters?.map{
                     return NSPredicate(format: "\($0.key) == %@", $0.value as! String)
                 }
                let managedObjects = try self.getManagedObjects(with: predicate?.first)
                let rawModels = managedObjects.compactMap{$0.model}
                
                guard let models = rawModels as? [T], !models.isEmpty else {
                    promise(.failure(CoreDataError.noData))
                    return
                }
                promise(.success(models))
            }
            catch let error{
                promise(.failure(CoreDataError.failure(description: error.localizedDescription)))
            }
        }
    }
    
    /// Inserts new entity to the context.
    /// - Parameters:
    ///   - item: Generic T which is conformable to Entity protocol.
    func insert<T>(item: T) where T : Entity {
        persistentContainer.viewContext.insert(item.toStorable(in: persistentContainer.viewContext) as! NSManagedObject)
        saveContext()
    }
    
    /// Deletes item from the context.
    /// - Parameters:
    ///   - item: Generic T which is conformable to Entity protocol.
    func delete<T>(item: T) where T : Entity {
        let predicate = NSPredicate(format: "id == %@", item.id)
        let items = try? getManagedObjects(with: predicate)
        if let item = items?.first {
            persistentContainer.viewContext.delete(item)
        }
        saveContext()
    }
    
    /// This method implements Object Relational Mapping. Converts T to the ManagedObject type.
    /// - Parameters:
    ///   - predicate: Optional Dictionary<String, Any> containing query. Ex: ["courseId":"id1"].
    /// - Returns: Array of [T.StoreType] where StoreType is a ManagedObject associated with T.
    private func getManagedObjects(with predicate: NSPredicate?) throws -> [T.StoreType] {
        let entityName = String(describing: T.StoreType.self)
        let request = NSFetchRequest<T.StoreType>(entityName: entityName)
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
