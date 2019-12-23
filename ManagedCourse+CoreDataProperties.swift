//
//  ManagedCourse+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/23/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedCourse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCourse> {
        return NSFetchRequest<ManagedCourse>(entityName: "ManagedCourse")
    }

    @NSManaged public var aliasName: String
    @NSManaged public var documentPath: String
    @NSManaged public var id: String
    @NSManaged public var title: String

}
