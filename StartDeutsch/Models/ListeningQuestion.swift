//
//  ListeningQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct ListeningQuestion {
    var question: String
    var answer: Int // index of the correct answer in choices array
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
