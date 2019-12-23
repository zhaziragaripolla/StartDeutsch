//
//  Course+Storable.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/5/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import CoreData

extension Course: Entity {
    public typealias StoreType = ManagedCourse
    
    public func toStorable(in context: NSManagedObjectContext) -> ManagedCourse {
        return ManagedCourse.getOrCreateSingle(with: self, from: context)
    }
}

extension ManagedCourse: Storable {
    
    public var model: Course {
        get {
            return Course(title: title, id: id, documentPath: documentPath, aliasName: aliasName)
        }
    }
}

extension Test: Entity {
    public typealias StoreType = ManagedTest
    
    public func toStorable(in context: NSManagedObjectContext) -> ManagedTest {
        return ManagedTest.getOrCreateSingle(with: self, from: context)
    }
}

extension ManagedTest: Storable {
 
    public var model: Test {
        get {
            return Test(id: id, courseId: courseId, documentPath: documentPath)
        }
    }
}


extension ListeningQuestion: Entity {
    public typealias StoreType = ManagedListeningQuestion
    
    public func toStorable(in context: NSManagedObjectContext) -> ManagedListeningQuestion{
        return ManagedListeningQuestion.getOrCreateSingle(with: self, from: context)
    }
}

extension ManagedListeningQuestion: Storable {
 
    public var model: ListeningQuestion {
        get {
            return ListeningQuestion(id: id, testId: testId, questionText: questionText, orderNumber: Int(orderNumber), answerChoices: answerChoices, correctChoiceIndex: Int(correctChoiceIndex), audioPath: audioPath)
        }
    }
}

extension ReadingQuestionEntity: Entity {
 
    public typealias StoreType = ManagedReadingQuestion
    
    public func toStorable(in context: NSManagedObjectContext) -> ManagedReadingQuestion{
        return ManagedReadingQuestion.getOrCreateSingle(with: self, from: context)
    }
}

extension ManagedReadingQuestion: Storable {
    public var model: ReadingQuestionEntity {
        get {
            return ReadingQuestionEntity(id: id, testId: testId, imagePath: imagePath ?? "", orderNumber:Int(orderNumber), questionText: questionText, questionTexts: questionTexts, correctAnswers: correctAnswers, answerImagePaths: answerImagePaths, correctChoiceIndex: Int(correctChoiceIndex), description: questionDescription, section: Int(section))
        }
    }
}

