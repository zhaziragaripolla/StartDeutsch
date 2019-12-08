//
//  ManagedTest+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/8/19.
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
    @NSManaged public var course: ManagedCourse?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension ManagedTest {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: ManagedListeningQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: ManagedListeningQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
