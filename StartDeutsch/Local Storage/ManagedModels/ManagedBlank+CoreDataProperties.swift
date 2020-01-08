//
//  ManagedBlank+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/4/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedBlank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedBlank> {
        return NSFetchRequest<ManagedBlank>(entityName: "ManagedBlank")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var text: String
    @NSManaged public var imagePath: String
    @NSManaged public var answerTexts: [String]

}
