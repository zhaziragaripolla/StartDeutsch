//
//  ReadingCourseViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import XCTest
@testable import StartDeutsch

class MockFirebaseManager: FirebaseManagerProtocol {
    var sendSuccessRequest = false
    var error = NSError(domain: "Check test on failure", code: 1, userInfo: [:])
    func getDocuments(_ path: String, completion: @escaping DocumentFetchingCompletion) {
        if sendSuccessRequest {
            completion(.success([]))
        }
        else {
            completion(.failure(error))
        }
    }
}

class ReadingCourseViewModelTests: XCTestCase {
    
    var sut: ReadingCourseViewModel!
    var firebaseManager: MockFirebaseManager!

    override func setUp() {
        super.setUp()
        sut = ReadingCourseViewModel(firebaseManager: firebaseManager, firebaseStorageManager: FirebaseStorageManager(), localDatabase: LocalDatabaseManager(), test: Test(id: "", courseId: "", documentPath: ""))
        firebaseManager = MockFirebaseManager()
    }

    override func tearDown() {
        sut = nil
        firebaseManager = nil
    }
    
    func testViewModel_whenMakesRemoteCall_urlIsCorrect(){
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
