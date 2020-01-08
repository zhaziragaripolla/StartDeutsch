//
//  ManagedWord+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/7/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWord> {
        return NSFetchRequest<ManagedWord>(entityName: "ManagedWord")
    }

    @NSManaged public var id: String
    @NSManaged public var courseId: String
    @NSManaged public var theme: String
    @NSManaged public var value: String

}
