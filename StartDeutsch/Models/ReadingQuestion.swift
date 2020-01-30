//
//  ReadingQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct ReadingQuestion{
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

extension ReadingQuestion{
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
