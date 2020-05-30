//
//  ManagedReadingQuestion+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedReadingQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedReadingQuestion> {
        return NSFetchRequest<ManagedReadingQuestion>(entityName: "ManagedReadingQuestion")
    }

    @NSManaged public var answerImagePaths: [String]?
    @NSManaged public var correctAnswers: [Bool]?
    @NSManaged public var correctChoiceIndex: Int16
    @NSManaged public var id: String
    @NSManaged public var imagePath: String?
    @NSManaged public var orderNumber: Int16
    @NSManaged public var descriptionText: String?
    @NSManaged public var questionText: String?
    @NSManaged public var questionTexts: [String]?
    @NSManaged public var section: Int16
    @NSManaged public var testId: String

}
