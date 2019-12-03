//
//  LocalListeningCourse+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalListeningCourse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalListeningCourse> {
        return NSFetchRequest<LocalListeningCourse>(entityName: "LocalListeningCourse")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var tests: NSSet?

}

// MARK: Generated accessors for tests
extension LocalListeningCourse {

    @objc(addTestsObject:)
    @NSManaged public func addToTests(_ value: LocalTest)

    @objc(removeTestsObject:)
    @NSManaged public func removeFromTests(_ value: LocalTest)

    @objc(addTests:)
    @NSManaged public func addToTests(_ values: NSSet)

    @objc(removeTests:)
    @NSManaged public func removeFromTests(_ values: NSSet)

}
