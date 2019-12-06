//
//  ListeningQuestion.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

final class ListeningQuestion: Decodable {
    var id: String
    var testId: String
    var questionText: String
    var orderNumber: Int
    var answerChoices: [String]?
    var correctChoiceIndex: Int // index of the correct answer in choices array
    var isMultipleChoice: Bool {
        guard answerChoices != nil else {
            return false
        }
        return true
    }
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
                "answerChoices": answerChoices?.singleString() ?? [],
                "correctChoiceIndex": correctChoiceIndex,
                "audioPath" : audioPath,
                "documentPath": documentPath
        ]
        default:
            return [
                "id": id,
                "testId": testId,
                "questionText": questionText,
                "correctChoiceIndex": correctChoiceIndex,
                "orderNumber": orderNumber,
                "audioPath" : audioPath,
                "documentPath": documentPath
            ]
        }
    }
    
    init(id: String, testId: String, questionText: String, orderNumber: Int, answerChoices: [String]?, correctChoiceIndex: Int, audioPath : String, documentPath: String){

        self.id = id
        self.testId = testId
        self.questionText = questionText
        self.orderNumber = orderNumber
        self.answerChoices = answerChoices
        self.correctChoiceIndex = correctChoiceIndex
        self.audioPath = audioPath
        self.documentPath = documentPath
    }
}

extension ListeningQuestion {
    enum CodingKeys: String, CodingKey {
         case answerChoices
         case audioPath
         case correctChoiceIndex
         case id
         case orderNumber
         case questionText
         case testId
         case documentPath
     }

    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(String.self, forKey: .id)
        let testId = try values.decode(String.self, forKey: .id)
        let questionText = try values.decode(String.self, forKey: .questionText)
        let orderNumber = try values.decode(Int.self, forKey: .orderNumber)
        let data = try values.decode(String?.self, forKey: .answerChoices)
        let answerChoices = data?.array()
        let correctChoiceIndex = try values.decode(Int.self, forKey: .correctChoiceIndex)
        let audioPath = try values.decode(String.self, forKey: .audioPath)
        let documentPath = try values.decode(String.self, forKey: .documentPath)
        
        self.init(id: id, testId: testId, questionText: questionText, orderNumber: orderNumber, answerChoices: answerChoices, correctChoiceIndex: correctChoiceIndex, audioPath: audioPath, documentPath: documentPath)
    }
}

extension ListeningQuestion: DocumentSerializable {
    convenience init?(dictionary: [String : Any], path: String) {
        guard let id = dictionary["id"] as? String,
            let testId = dictionary["testId"] as? String,
            let questionText = dictionary["questionText"] as? String,
            let correctChoiceIndex = dictionary["correctChoiceIndex"] as? Int,
            let orderNumber = dictionary["orderNumber"] as? Int,
            let audioPath = dictionary["audioPath"] as? String,
            let answerChoices = dictionary["answerChoices"] as? [String]?
            else {return nil}
             
        self.init(id: id, testId: testId, questionText: questionText, orderNumber: orderNumber, answerChoices: answerChoices, correctChoiceIndex: correctChoiceIndex, audioPath : audioPath, documentPath: path)
     }
}

extension Array where Element == String {
    func singleString()-> String {
        return self.joined(separator: ",")
    }
}

extension String {
    func array()-> [String] {
        return self.components(separatedBy: ",")
    }
}
