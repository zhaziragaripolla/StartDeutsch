//
//  CourseListViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 1/8/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
import CoreData
@testable import StartDeutsch

class CourseTests: XCTestCase {

    func testSuccessfulInit() {
        let testSuccessfullDictionary: Dictionary<String, Any> = ["id": "1",
                                    "title": "Title",
                                    "aliasName": "test"]

        XCTAssertNotNil(Course(dictionary: testSuccessfullDictionary, path: "Users"))
    }
}
//
//class MockCoreDataRepository<RepositoryObject>: Repository where RepositoryObject: Entity, RepositoryObject.StoreType: NSManagedObject, RepositoryObject.StoreType.EntityObject == RepositoryObject {
//    func getAll(where predicate: NSPredicate?) throws -> [Course] {
//        <#code#>
//    }
//
//    func insert(item: Course) throws {
//        <#code#>
//    }
//
//    func update(item: Course) throws {
//        <#code#>
//    }
//
//    func delete(item: Course) throws {
//        <#code#>
//    }
//
//    typealias EntityObject = Course
//
//}

class CourseListViewModelTests: XCTestCase {
    
    var sut: CourseListViewModel!
    var firebaseManager: FirebaseManagerProtocol!
    var repository: CoreDataRepository<Course>!
    
    override func setUp() {
        super.setUp()
        firebaseManager = MockFirebaseManager()
        repository = CoreDataRepository<Course>()
        sut = CourseListViewModel(firebaseManager: firebaseManager, repository: repository)
    }

    override func tearDown() {
        sut = nil
        firebaseManager = nil
        repository = nil
        super.tearDown()
    }
    
    func testViewModelGetsCourseList(){
        sut.getCourses()
        XCTAssertNotEqual(sut.courses.count, 0)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
