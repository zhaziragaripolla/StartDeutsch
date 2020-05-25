//
//  Models+Storable.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/5/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

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
            return Course(title: title, id: id, aliasName: aliasName, description: descriptionText)
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
            return Test(id: id, courseId: courseId)
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

extension ReadingQuestion: Entity {
 
    public typealias StoreType = ManagedReadingQuestion
    
    public func toStorable(in context: NSManagedObjectContext) -> ManagedReadingQuestion{
        return ManagedReadingQuestion.getOrCreateSingle(with: self, from: context)
    }
}

extension ManagedReadingQuestion: Storable {
    public var model: ReadingQuestion {
        get {
            return ReadingQuestion(id: id, testId: testId, imagePath: imagePath ?? "", orderNumber:Int(orderNumber), questionText: questionText, questionTexts: questionTexts, correctAnswers: correctAnswers, answerImagePaths: answerImagePaths, correctChoiceIndex: Int(correctChoiceIndex), description: questionDescription, section: Int(section))
        }
    }
}

extension Blank: Entity {
    
    public typealias StoreType = ManagedBlank
       
       public func toStorable(in context: NSManagedObjectContext) -> ManagedBlank{
           return ManagedBlank.getOrCreateSingle(with: self, from: context)
       }
}

extension Letter: Entity {
    public typealias StoreType = ManagedLetter
       
       public func toStorable(in context: NSManagedObjectContext) -> ManagedLetter{
           return ManagedLetter.getOrCreateSingle(with: self, from: context)
       }
}

extension ManagedBlank: Storable {
    public var model: Blank {
          get {
              return Blank(id: id, title: title, text: text, imagePath: imagePath, answerTexts: answerTexts)
          }
      }
}

extension ManagedLetter: Storable {
    public var model: Letter {
          get {
              return Letter(id: id, title: title, task: task, points: points, answerImagePath: answerImagePath)
          }
      }
}

extension Word: Entity {
    public typealias StoreType = ManagedWord
       
       public func toStorable(in context: NSManagedObjectContext) -> ManagedWord{
           return ManagedWord.getOrCreateSingle(with: self, from: context)
       }
}

extension ManagedWord: Storable {
    public var model: Word {
          get {
            return Word(id:id, courseId: courseId, theme: theme, value: value)
          }
      }
}


extension Card: Entity {
    public typealias StoreType = ManagedCard
       
       public func toStorable(in context: NSManagedObjectContext) -> ManagedCard{
           return ManagedCard.getOrCreateSingle(with: self, from: context)
       }
}

extension ManagedCard: Storable {
    public var model: Card {
          get {
            return Card(id:id, imageUrl: imageUrl, courseId: courseId)
          }
      }
}
