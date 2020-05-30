//
//  ReadingQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct ReadingQuestion: Decodable{
    
    public var id: String
    var testId: String
    var imagePath: String?
    var orderNumber: Int
    var questionText: String?
    var questionTexts: [String]?
    var correctAnswers: [Bool]?
    var answerImagePaths: [String]?
    var correctChoiceIndex: Int?
    var description: String?
    var section: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case testId = "test"
        case imagePath
        case orderNumber
        case questionText
        case questionTexts
        case correctAnswers
        case answerImagePaths
        case correctChoiceIndex
        case description
        case section
    }
    
    public var dictionary: Dictionary<String, Any>  {
        return [
            "id":id,
            "testId":testId,
            "imagePath":imagePath ?? "",
            "questionTexts": questionTexts ?? [],
            "orderNumber":orderNumber,
            "correctAnswers":correctAnswers ?? [],
            "questionText":questionText ?? "",
            "answerImagePaths":answerImagePaths ?? [],
            "correctChoiceIndex":correctChoiceIndex ?? -1,
            "descriptionText": description ?? "",
            "section":section
        ]
    }
}

extension ReadingQuestion: Equatable{
    static public func ==(lhs: ReadingQuestion, rhs: ReadingQuestion) -> Bool {
        if lhs.id == rhs.id{
            return true
        }
        return false
    }
}
