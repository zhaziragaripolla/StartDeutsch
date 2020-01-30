//
//  ManagedCourse+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/28/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
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
    @NSManaged public var descriptionText: String

}
