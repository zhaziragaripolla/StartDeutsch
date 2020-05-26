//
//  MockReadingCourseDataSourceProtocol.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine
@testable import Start_Deutsch

class MockReadingCourseDataSource: ReadingCourseDataSourceProtocol{
    
    var getAllCallCount: Int = 0
    var createCallCount: Int = 0
    var returnErrorEnabled: Bool = false
    var error: Error! = nil
    
    let questions: [ReadingQuestion] = [
        ReadingQuestion(id: UUID().description, testId: "id1", imagePath: nil, orderNumber: 1, questionText: nil, questionTexts: nil, correctAnswers: [false, true], answerImagePaths: nil, correctChoiceIndex: nil, description: nil, section: 1),
        ReadingQuestion(id: UUID().description, testId: "id1", imagePath: nil, orderNumber: 2, questionText: nil, questionTexts: nil, correctAnswers: [false, true, true], answerImagePaths: nil, correctChoiceIndex: nil, description: nil, section: 1),
        ReadingQuestion(id: UUID().description, testId: "id1", imagePath: nil, orderNumber: 3, questionText: nil, questionTexts: nil, correctAnswers: nil, answerImagePaths: nil, correctChoiceIndex: 0, description: nil, section: 2),
        ReadingQuestion(id: UUID().description, testId: "id1", imagePath: nil, orderNumber: 4, questionText: nil, questionTexts: nil, correctAnswers: nil, answerImagePaths: nil, correctChoiceIndex: 1, description: nil, section: 2),
        ReadingQuestion(id: UUID().description, testId: "id1", imagePath: nil, orderNumber: 5, questionText: nil, questionTexts: nil, correctAnswers: nil, answerImagePaths: nil, correctChoiceIndex: 1, description: nil, section: 3),
        ReadingQuestion(id: UUID().description, testId: "id1", imagePath: nil, orderNumber: 6, questionText: nil, questionTexts: nil, correctAnswers: nil, answerImagePaths: nil, correctChoiceIndex: 1, description: nil, section: 3),
    ]

    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[ReadingQuestion], Error> {
        guard let parameters = parameters,
            let testId = parameters["testId"] as? String else {
                fatalError()
        }
        getAllCallCount += 1
        switch returnErrorEnabled {
        case true:
            return Future{ promise in
                promise(.failure(self.error))
            }
        default:
            return Future{ promise in
                promise(.success(self.questions.filter{
                    $0.testId == testId
                }))
            }
        }
    }
    
    func create(item: ReadingQuestion) {
        createCallCount += 1
    }
    
    func delete(item: ReadingQuestion) {}
        
}
