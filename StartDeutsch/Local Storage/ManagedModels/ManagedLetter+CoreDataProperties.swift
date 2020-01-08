//
//  ManagedLetter+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/4/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedLetter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedLetter> {
        return NSFetchRequest<ManagedLetter>(entityName: "ManagedLetter")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var task: String
    @NSManaged public var points: [String]
    @NSManaged public var answerImagePath: String

}
