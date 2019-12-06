//
//  Course+Storable.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/5/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import CoreData

extension Course: Entity {
    public typealias StoreType = ManagedCourse
    
    public func toStorable(in context: NSManagedObjectContext) -> ManagedCourse {
        return ManagedCourse.getOrCreateSingle(with: id, from: context)
    }
}

extension ManagedCourse: Storable {
    
    public var model: Course {
        get {
            return Course(title: title, id: id, documentPath: documentPath, aliasName: aliasName)
        }
    }
}

