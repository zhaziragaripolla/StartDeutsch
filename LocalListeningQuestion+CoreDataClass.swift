//
//  LocalListeningQuestion+CoreDataClass.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LocalListeningQuestion)
public class LocalListeningQuestion: NSManagedObject {
    enum CodingKeys: String, CodingKey {
        case answerChoices
        case audioPath
        case correctChoiceIndex
        case id
        case orderNumber
        case questionText
        case testId
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(answerChoices, forKey: .answerChoices)
        try container.encode(audioPath, forKey: .audioPath)
        try container.encode(correctChoiceIndex, forKey: .correctChoiceIndex)
        try container.encode(id, forKey: .id)
        try container.encode(orderNumber, forKey: .orderNumber)
        try container.encode(questionText, forKey: .questionText)
        try container.encode(testId, forKey: .testId)
        
    }
}