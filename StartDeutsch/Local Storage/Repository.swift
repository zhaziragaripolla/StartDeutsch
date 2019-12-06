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
    
    func toStorable(in context: NSManagedObjectContext) -> StoreType
}

public protocol Storable {
    associatedtype EntityObject: Entity
    
    var model: EntityObject { get }
    var id: String { get }
}

extension Storable where Self: NSManagedObject {
    
    static func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> Self {
        let result = single(with: id, from: context) ?? insertNew(in: context)
        result.setValue(id, forKey: "id")
        return result
    }
    
    static func single(with id: String, from context: NSManagedObjectContext) -> Self? {
        return fetch(with: id, from: context)?.first
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self {
        return Self(context:context)
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
