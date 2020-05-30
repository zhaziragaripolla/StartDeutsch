//
//  ManagedTest+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedTest> {
        return NSFetchRequest<ManagedTest>(entityName: "ManagedTest")
    }

    @NSManaged public var courseId: String
    @NSManaged public var id: String

}
