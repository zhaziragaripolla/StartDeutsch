//
//  MockListeningCourseDataSource.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Combine
@testable import Start_Deutsch

class MockListeningCourseDataSource: ListeningCourseDataSourceProtocol{

    let questions: [ListeningQuestion] = [
        ListeningQuestion(id: UUID().description, testId: "id1", questionText: "", orderNumber: 1, answerChoices: nil, correctChoiceIndex: 0, audioPath: ""),
        ListeningQuestion(id: UUID().description, testId: "id1", questionText: "", orderNumber: 2, answerChoices: nil, correctChoiceIndex: 1, audioPath: ""),
        ListeningQuestion(id: UUID().description, testId: "id1", questionText: "", orderNumber: 3, answerChoices: nil, correctChoiceIndex: 0, audioPath: ""),
        ListeningQuestion(id: UUID().description, testId: "id1", questionText: "", orderNumber: 4, answerChoices: nil, correctChoiceIndex: 2, audioPath: ""),
        ListeningQuestion(id: UUID().description, testId: "id1", questionText: "", orderNumber: 5, answerChoices: nil, correctChoiceIndex: 1, audioPath: ""),
        ListeningQuestion(id: UUID().description, testId: "id1", questionText: "", orderNumber: 6, answerChoices: nil, correctChoiceIndex: 0, audioPath: ""),
        ListeningQuestion(id: UUID().description, testId: "id2", questionText: "", orderNumber: 1, answerChoices: nil, correctChoiceIndex: 2, audioPath: ""),
    ]
    
    var getAllCallCount: Int = 0
    var createCallCount: Int = 0
    var returnErrorEnabled: Bool = false
    var error: Error! = nil

    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[ListeningQuestion], Error> {
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
    
    func create(item: ListeningQuestion) {
        createCallCount += 1
    }
    
    func delete(item: ListeningQuestion) {}
    
}
