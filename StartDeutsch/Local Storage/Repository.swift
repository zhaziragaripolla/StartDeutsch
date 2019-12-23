//
//  Repository.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/5/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import CoreData

protocol Repository {
    associatedtype EntityObject: Entity
    
    func getAll(where predicate: NSPredicate?) throws -> [EntityObject]
    func insert(item: EntityObject) throws
    func update(item: EntityObject) throws
    func delete(item: EntityObject) throws
}

public protocol Entity {
    associatedtype StoreType: Storable
    var dictionary: Dictionary<String, Any>  { get }
    var id: String { get }
    func toStorable(in context: NSManagedObjectContext) -> StoreType
}

public protocol Storable {
    associatedtype EntityObject: Entity
    
    var model: EntityObject { get }
}

extension Storable where Self: NSManagedObject {
    
    static func getOrCreateSingle(with model: EntityObject, from context: NSManagedObjectContext) -> Self {
        let result = single(with: model.id, from: context) ?? insertNew(with: model.dictionary, in: context)
        print(result.entity)
        return result
    }
    
    static func single(with id: String, from context: NSManagedObjectContext) -> Self? {
        return fetch(with: id, from: context)?.first
    }
    
    static func insertNew(with attributes: Dictionary<String, Any>, in context: NSManagedObjectContext) -> Self {
        let newObject = Self(context:context)
        newObject.setValuesForKeys(attributes)
        return newObject
    }
    
    static func fetch(with id: String, from context: NSManagedObjectContext) -> [Self]? {
        let entityName = String(describing: Self.self)
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        let result: [Self]? = try? context.fetch(fetchRequest)
        
        return result
    }
}
