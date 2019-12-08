//
//  ListeningQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct ListeningQuestion {
    public var id: String = ""
    var testId: String
    var questionText: String
    var orderNumber: Int
    var answerChoices: [String]?
    var correctChoiceIndex: Int // index of the correct answer in choices array
    var isMultipleChoice: Bool {
        return answerChoices != nil ? true : false
    }
    var audioPath: String
//    var documentPath: String
//    var storedAudioPath: String
    
    public var dictionary: [String: Any] {
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
//                "documentPath": documentPath
        ]
        default:
            return [
                "id": id,
                "testId": testId,
                "questionText": questionText,
                "correctChoiceIndex": correctChoiceIndex,
                "orderNumber": orderNumber,
                "audioPath" : audioPath,
//                "documentPath": documentPath
            ]
        }
    }
    
}

extension ListeningQuestion {
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let questionText = dictionary["questionText"] as? String,
            let correctChoiceIndex = dictionary["correctChoiceIndex"] as? Int,
            let orderNumber = dictionary["orderNumber"] as? Int,
            let audioPath = dictionary["audioPath"] as? String,
            let answerChoices = dictionary["answerChoices"] as? [String]?
            else {return nil}
             
        self.init(id: id, testId: testId, questionText: questionText, orderNumber: orderNumber, answerChoices: answerChoices, correctChoiceIndex: correctChoiceIndex, audioPath : audioPath)
     }
}

