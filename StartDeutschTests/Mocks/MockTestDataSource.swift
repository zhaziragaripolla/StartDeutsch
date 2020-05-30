//
//  MockTestListDataSourceProtocol.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Combine
import Foundation
@testable import Start_Deutsch

class MockTestDataSource: TestDataSourceProtocol{

    let tests: [Test] = [
        Test(id: UUID().description, courseId: "id1"),
        Test(id: UUID().description, courseId: "id1"),
        Test(id: UUID().description, courseId: "id1"),
        
        Test(id: UUID().description, courseId: "id2"),
        Test(id: UUID().description, courseId: "id2"),
    ]
    
    var getAllCallCount: Int = 0
    var createCallCount: Int = 0
    var returnErrorEnabled: Bool = false
    var error: Error! = nil

    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Test], Error> {
        guard let parameters = parameters,
            let courseId = parameters["courseId"] as? String else {
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
                promise(.success(self.tests.filter{
                    $0.courseId == courseId
                }))
            }
        }
    }
    
    func create(item: Test) {
        createCallCount += 1
    }
    
    func delete(item: Test) {}
    
}
