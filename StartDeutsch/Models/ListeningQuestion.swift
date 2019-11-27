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
    var isMultipleChoice: Bool
    var audioPath: String
    
    var dictionary: [String: Any] {
        switch isMultipleChoice {
        case true:
            return [
                "question": question,
                "answer": answer,
                "number": number,
                "choices": choices ?? [],
                "audioPath" : audioPath
        ]
        default:
            return [
                "question": question,
                "answer": answer,
                "number": number,
                "audioPath" : audioPath
            ]
        }
  
    }
}

extension ListeningQuestion: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let question = dictionary["question"] as? String,
            let answer = dictionary["answer"] as? Int,
            let number = dictionary["number"] as? Int,
            let audioPath = dictionary["audioPath"] as? String,
            let choices = dictionary["choices"] as? [String]?,
            let isMultipleChoice = (choices != nil) ? true : false
            else {return nil}
             
        self.init(question: question, answer: answer, number: number, choices: choices, isMultipleChoice: isMultipleChoice, audioPath : audioPath)
     }
}
