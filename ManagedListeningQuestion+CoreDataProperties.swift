//
//  ManagedListeningQuestion+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/8/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedListeningQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedListeningQuestion> {
        return NSFetchRequest<ManagedListeningQuestion>(entityName: "ManagedListeningQuestion")
    }

    @NSManaged public var answerChoices: [String]?
    @NSManaged public var audioPath: String
    @NSManaged public var correctChoiceIndex: Int16
    @NSManaged public var id: String
    @NSManaged public var orderNumber: Int16
    @NSManaged public var questionText: String
//    @NSManaged public var storedAudioPath: String
    @NSManaged public var testId: String
    @NSManaged public var test: ManagedTest?

}
