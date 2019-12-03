//
//  LocalTest+CoreDataProperties.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalTest> {
        return NSFetchRequest<LocalTest>(entityName: "LocalTest")
    }

    @NSManaged public var courseId: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var course: LocalListeningCourse?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension LocalTest {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: LocalListeningQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: LocalListeningQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
