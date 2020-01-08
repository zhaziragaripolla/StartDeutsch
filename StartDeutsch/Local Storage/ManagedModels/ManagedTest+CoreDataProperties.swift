//
//  ManagedTest+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/23/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedTest> {
        return NSFetchRequest<ManagedTest>(entityName: "ManagedTest")
    }

    @NSManaged public var courseId: String
    @NSManaged public var documentPath: String
    @NSManaged public var id: String

}
