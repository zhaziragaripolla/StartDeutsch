//
//  ReadingQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ReadingQuestion {
    var id: String { get }
    var testId: String { get }
    var orderNumber: Int { get }
}


public struct ReadingQuestionEntity{
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
            "questionDescription": description ?? "",
            "section":section
        ]
    }
}

extension ReadingQuestionEntity{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let imagePath = dictionary["imagePath"] as? String?,
            let questionTexts = dictionary["questionTexts"] as? [String]?,
            let correctAnswers = dictionary["correctAnswers"] as? [Bool]?,
            let orderNumber = dictionary["orderNumber"] as? Int,
            let questionText = dictionary["questionText"] as? String?,
            let answerImagePaths = dictionary["answerImagePaths"] as? [String]?,
            let correctChoiceIndex = dictionary["correctChoiceIndex"] as? Int?,
            let description = dictionary["description"] as? String?,
            let section = dictionary["section"] as? Int else { return nil}
        self.init(id: id, testId: testId, imagePath: imagePath, orderNumber: orderNumber, questionText: questionText, questionTexts: questionTexts, correctAnswers: correctAnswers, answerImagePaths: answerImagePaths, correctChoiceIndex: correctChoiceIndex, description: description, section: section)
    }
}

struct ReadingPartOneQuestion: ReadingQuestion{
    var id: String
    var testId: String
    var imagePath: String
    var questionTexts: [String]
    var correctAnswers: [Bool]
    var orderNumber: Int

    var dictionary: [String: Any]{
        return [
            "id":id,
            "testId":testId,
            "imagePath":imagePath,
            "questionTexts": questionTexts,
            "correctAnswers": correctAnswers,
            "orderNumber":orderNumber
        ]
    }
}

extension ReadingPartOneQuestion{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let imagePath = dictionary["imagePath"] as? String,
            let questionTexts = dictionary["questionTexts"] as? [String],
            let correctAnswers = dictionary["correctAnswers"] as? [Bool],
            let orderNumber = dictionary["orderNumber"] as? Int
            else { return nil}
        self.init(id: id, testId: testId, imagePath: imagePath, questionTexts: questionTexts, correctAnswers: correctAnswers, orderNumber: orderNumber)
    }
}

struct ReadingPartTwoQuestion: ReadingQuestion{
    var id: String
    var testId: String
    var questionText: String
    var answerImagePaths: [String]
    var correctChoiceIndex: Int
    var orderNumber: Int
    var dictionary: [String: Any]{
        return [
            "id":id,
            "testId":testId,
            "questionText":questionText,
            "answerImagePaths":answerImagePaths,
            "correctChoiceIndex":correctChoiceIndex,
            "orderNumber":orderNumber
        ]
    }
}
extension ReadingPartTwoQuestion{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let answerImagePaths = dictionary["answerImagePaths"] as? [String],
            let questionText = dictionary["questionText"] as? String,
            let correctChoiceIndex = dictionary["correctChoiceIndex"] as? Int,
            let orderNumber = dictionary["orderNumber"] as? Int
            else { return nil}
        self.init(id: id, testId: testId, questionText: questionText, answerImagePaths: answerImagePaths, correctChoiceIndex: correctChoiceIndex, orderNumber: orderNumber)
    }
}

struct ReadingPartThreeQuestion: ReadingQuestion{
    var id: String
    var testId: String
    var questionText: String
    var description: String
    var correctChoiceIndex: Int
    var imagePath: String
    var orderNumber: Int
    var dictionary: [String: Any]{
        return [
            "id":id,
            "testId":testId,
            "questionText":questionText,
            "description":description,
            "correctChoiceIndex":correctChoiceIndex,
            "imagePath":imagePath,
            "orderNumber":orderNumber
        ]
    }
}

extension ReadingPartThreeQuestion {
    init?(dictionary: [String : Any]){
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let questionText = dictionary["questionText"] as? String,
            let description = dictionary["description"] as? String,
            let correctChoiceIndex = dictionary["correctChoiceIndex"] as? Int,
            let imagePath = dictionary["imagePath"] as? String,
            let orderNumber = dictionary["orderNumber"] as? Int
            else { return nil}
        self.init(id: id, testId: testId, questionText: questionText, description: description, correctChoiceIndex: correctChoiceIndex, imagePath: imagePath, orderNumber: orderNumber)
    }
}
