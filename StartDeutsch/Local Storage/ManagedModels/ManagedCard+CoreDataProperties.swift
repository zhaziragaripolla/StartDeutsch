//
//  ManagedCard+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/8/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCard> {
        return NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
    }

    @NSManaged public var id: String
    @NSManaged public var imageUrl: String
    @NSManaged public var courseId: String

}
