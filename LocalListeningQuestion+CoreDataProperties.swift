//
//  LocalListeningQuestion+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalListeningQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalListeningQuestion> {
        return NSFetchRequest<LocalListeningQuestion>(entityName: "LocalListeningQuestion")
    }

    @NSManaged public var answerChoices: String?
    @NSManaged public var audioPath: String?
    @NSManaged public var correctChoiceIndex: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var orderNumber: Int16
    @NSManaged public var questionText: String?
    @NSManaged public var testId: UUID?
    @NSManaged public var test: LocalTest?

}
