//
//  ManagedCourse+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/8/19.
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
    @NSManaged public var tests: NSSet?

}

// MARK: Generated accessors for tests
extension ManagedCourse {

    @objc(addTestsObject:)
    @NSManaged public func addToTests(_ value: ManagedTest)

    @objc(removeTestsObject:)
    @NSManaged public func removeFromTests(_ value: ManagedTest)

    @objc(addTests:)
    @NSManaged public func addToTests(_ values: NSSet)

    @objc(removeTests:)
    @NSManaged public func removeFromTests(_ values: NSSet)

}
