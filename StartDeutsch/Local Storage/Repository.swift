//
//  Repository.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/5/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import CoreData

/// Defined below protocols solve problem of ORM: mismatching between plain models(structs) and Core Data models(NSManagedObjects).

/// A type that can map itself to the NSManagedObject type.
public protocol Entity {
    
    associatedtype StoreType: Storable
    
    /// The dictionary holding properties and values to be set to the NSManagedObject instance.
    var dictionary: Dictionary<String, Any>  { get }
    
    /// The unique property.
    var id: String { get }
    
    /// Converts the given Entity to the NSManagedObject type.
    /// - parameter context: The NSManagedObjectContext that contains associated NSManagedObject.
    func toStorable(in context: NSManagedObjectContext) -> StoreType
}

/// A type that can map itself to the Entity type.
public protocol Storable {
    
    associatedtype EntityObject: Entity
    
    /// Returns the Entity associated with given NSManagedObject.
    var model: EntityObject { get }
}

extension Storable where Self: NSManagedObject {
    
    /// Returns the instance of NSManagedObject mapped to the given model.
    /// - Parameters:
    ///   - model: EntityObject to be mapped to the NSManagedObject.
    ///   - context: The NSManagedObjectContext that contains NSManagedObject.
    /// - Returns: The NSManagedObject.
    static func getOrCreateSingle(with model: EntityObject, from context: NSManagedObjectContext) -> Self {
        return fetch(with: model.id, from: context)?.first ?? insertNew(with: model.dictionary, in: context)
    }
    
    /// Returns inserted NSManagedObject with given properties and values in a given context.
    /// - Parameters:
    ///   - attributes: Dictionary<String, Any> containing properties and values to be set to the new NSManagedObject.
    ///   - context: The NSManagedObjectContext that to be used to insert a new instance of NSManagedObject.
    /// - Returns: The insertedNSManagedObject.
    private static func insertNew(with attributes: Dictionary<String, Any>, in context: NSManagedObjectContext) -> Self {
        let newObject = Self(context:context)
        newObject.setValuesForKeys(attributes)
        return newObject
    }
    
    /// Returns the result of fetching NSManagedObject against given ID in a given context.
    /// - Parameters:
    ///   - id: Unique value to be used to fetch an object.
    ///   - context: The NSManagedObjectContext that to be used to manipulate NSManagedObject.
    /// - Returns: The Optional Array of existing NSManagedObject.
    private static func fetch(with id: String, from context: NSManagedObjectContext) -> [Self]? {
        let entityName = String(describing: Self.self)
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        let result: [Self]? = try? context.fetch(fetchRequest)
        
        return result
    }
}
