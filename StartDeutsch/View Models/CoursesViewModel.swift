//
//  CoursesViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Answer {
    var options: [String]
    var checks: [Bool]
    
    func isCorrect(_ index: Int)-> Bool {
        return checks[index]
    }
    
    var dictionary: [String: Any] {
       return [
         "isCorrect": checks,
         "strings": options
       ]
     }
}

extension Answer: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let options = dictionary["strings"] as? [String],
            let checks = dictionary["isCorrect"] as? [Bool] else { return nil }
        
        self.init(options: options, checks: checks)
    }
    
}

struct ListeningQuestion {
    var question: String
    var answer: Int
    var number: Int
    var choices: [String]?
    var isMultipleChoice: Bool = true
    
    var dictionary: [String: Any] {
        switch isMultipleChoice {
        case true:
            return [
                "question": question,
                "answer": answer,
                "number": number,
                "choices": choices ?? []
            ]
        default:
            return [
                "question": question,
                "answer": answer,
                "number": number,
            ]
        }
  
    }
}

extension ListeningQuestion: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let question = dictionary["question"] as? String,
            let answer = dictionary["answer"] as? Int,
            let number = dictionary["number"] as? Int,
            let choices = dictionary["choices"] as? [String]? else {return nil}
             
        self.init(question: question, answer: answer, number: number, choices: choices)
     }
}

enum Courses {
    case listening(String)
    case reading
    case writing
    case speaking
}

class CoursesViewModel {
    var firestore: Firestore { return Firestore.firestore() }
    
    let courses: [String] = ["Hören", "Lesen", "Schreiben", "Sprechen"]
    
    var tests: [DocumentReference] = []
    
    
    func save(question: ListeningQuestion){
        let collection = Firestore.firestore().collection("/courses/german/listening/test1/questions")
        collection.addDocument(data: question.dictionary)
    }
    
}
