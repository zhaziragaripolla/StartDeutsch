//
//  ListeningQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct ListeningQuestion: Decodable {
    
    public var id: String
    var testId: String
    var questionText: String
    var orderNumber: Int
    var answerChoices: [String]?
    var correctChoiceIndex: Int // index of the correct answer in choices array
    var audioPath: String
    var isMultipleChoice: Bool {
        guard let choices = answerChoices else { return false}
        return choices.isEmpty ? false : true
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case questionText
        case orderNumber
        case answerChoices
        case correctChoiceIndex
        case audioPath
        case testId = "test"
    }
    
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
        ]
        default:
            return [
                "id": id,
                "testId": testId,
                "questionText": questionText,
                "correctChoiceIndex": correctChoiceIndex,
                "orderNumber": orderNumber,
                "audioPath" : audioPath,
            ]
        }
    }
}

extension ListeningQuestion: Equatable{
    static public func ==(lhs: ListeningQuestion, rhs: ListeningQuestion) -> Bool {
        if lhs.id == rhs.id{
            return true
        }
        return false
    }
}
