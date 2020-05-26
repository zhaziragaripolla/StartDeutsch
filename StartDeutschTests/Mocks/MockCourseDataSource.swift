//
//  MockCourseListDataSource.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Combine
@testable import Start_Deutsch

class MockCourseDataSource: CourseDataSourceProtocol{
    
    // By default returns success responses.
    var getAllCallCount: Int = 0
    var createCallCount: Int = 0
    var returnErrorEnabled: Bool = false
    var error: Error! = nil
    
    let courses: [Course] = [
        Course(title: "Hören", id: "id1", aliasName: "listening", description: ""),
        Course(title: "Lesen", id: "id2", aliasName: "reading", description: ""),
        Course(title: "Schreiben", id: "id3", aliasName: "writing", description: ""),
        Course(title: "Sprechen", id: "id4", aliasName: "speaking", description: ""),
    ]
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Course], Error> {
        getAllCallCount += 1
        switch returnErrorEnabled {
        case true:
            return Future{ promise in
                promise(.failure(self.error))
            }
        default:
            return Future{ promise in
                promise(.success(self.courses))
            }
        }
    }
    
    func create(item: Course) {
        createCallCount += 1
    }
    
    func delete(item: Course) {}
}
