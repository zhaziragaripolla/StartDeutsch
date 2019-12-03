//
//  ListeningQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct ListeningQuestion {
    var id: String
    var testId: String
    var questionText: String
    var orderNumber: Int
    var answerChoices: [String]?
    var correctChoiceIndex: Int // index of the correct answer in choices array
    var isMultipleChoice: Bool
    var audioPath: String
    var documentPath: String
    
    var dictionary: [String: Any] {
        switch isMultipleChoice {
        case true:
            return [
                "id": id,
                "testId": testId,
                "orderNumber": orderNumber,
                "questionText": questionText,
                "answerChoices": answerChoices ?? [],
                "correctChoiceIndex": correctChoiceIndex,
                "audioPath" : audioPath,
        ]
        default:
            return [
                "id": id,
                "testId": testId,
                "questionText": questionText,
                "correctChoiceIndex": correctChoiceIndex,
                "orderNumber": orderNumber,
                "audioPath" : audioPath
            ]
        }
  
    }
}

extension ListeningQuestion: DocumentSerializable {
    init?(dictionary: [String : Any], path: String) {
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let questionText = dictionary["questionText"] as? String,
            let correctChoiceIndex = dictionary["correctChoiceIndex"] as? Int,
            let orderNumber = dictionary["orderNumber"] as? Int,
            let audioPath = dictionary["audioPath"] as? String,
            let answerChoices = dictionary["answerChoices"] as? [String]?,
            let isMultipleChoice = (answerChoices != nil) ? true : false
            else {return nil}
             
        self.init(id: id, testId: testId, questionText: questionText, orderNumber: orderNumber, answerChoices: answerChoices, correctChoiceIndex: correctChoiceIndex, isMultipleChoice: isMultipleChoice, audioPath : audioPath, documentPath: path)
     }
}
