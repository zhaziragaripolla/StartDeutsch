//
//  TestListViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/24/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
import Combine
@testable import Start_Deutsch

class MockTestListRepo: TestDataSourceProtocol{

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

class TestListViewModelTests: XCTestCase {
    
    var sut: TestListViewModel!
    var localRepo: MockTestListRepo!
    var remoteRepo: MockTestListRepo!
    var course: Course!
    
    private var callDidDownloadData: XCTestExpectation!
    private var callErrorDelegate: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        localRepo = MockTestListRepo()
        remoteRepo = MockTestListRepo()
        course = Course(title: "It's a title!", id: "id1", aliasName: "Some name.", description: "Super course.")
        sut = TestListViewModel(remoteRepo: remoteRepo,
                                localRepo: localRepo,
                                course: course)
        sut.delegate = self
        sut.errorDelegate = self
    }
    
    override func tearDown() {
        sut = nil
        localRepo = nil
        remoteRepo = nil
        super.tearDown()
    }
    
    func testViewModel_whenGetTests_callsLocalRepo(){
        
        // when
        sut.getTests()
        
        // then
        XCTAssertEqual(localRepo.getAllCallCount, 1)
    }
    
    func testViewModel_whenGetTestsFromLocalRepo_onSuccess_updateTests(){
        // given
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        let expectedTests = localRepo.tests.filter{ $0.courseId == course.id }
        
        // when
        sut.getTests()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
 
        XCTAssertEqual(expectedTests, sut.tests, "Returned expected tests related to chosen course.")
    }
    
    func testViewModel_whenGetTestsFromLocalRepo_onFailure_callRemoteRepo(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        // when
        sut.getTests()
        
        // then
        XCTAssertEqual(remoteRepo.getAllCallCount, 1)
    }
    
    func testViewModel_whenGetTestsFromRemoteRepo_onSuccess_updateTests(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = false
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        
        let expectedTests = remoteRepo.tests.filter{ $0.courseId == course.id }
        
        // when
        sut.getTests()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
        XCTAssertEqual(expectedTests, sut.tests, "Returned expected models.")
    }
    
    func testViewModel_whenGetTestsFromRemoteRepo_onSuccess_saveTests(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = false
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        
        let expectedTestsCount = remoteRepo.tests.filter{ $0.courseId == course.id }.count
        
        // when
        sut.getTests()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
        XCTAssertEqual(localRepo.createCallCount, expectedTestsCount, "Saved models to Core Data.")
    }
    
    
    func testViewModel_whenGetTestsFromRemoteRepo_onFailure_callErorDelegate(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = true
        remoteRepo.error = APIError.networking(statusCode: 500, detail: "")
        
        callErrorDelegate = expectation(description: "Error Delegate is being called.")
        
        // when
        sut.getTests()
        
        // then
        wait(for: [callErrorDelegate], timeout: 1)
    }
    
}

extension TestListViewModelTests: ViewModelDelegate, ErrorDelegate{
    func didCompleteLoading() {
        
    }
    
    func didDownloadData() {
        callDidDownloadData.fulfill()
    }
    
    func networkOffline() {
        
    }
    
    func networkOnline() {
        
    }
    
    func didStartLoading() {
        
    }
    
    func showError(message: String) {
        callErrorDelegate.fulfill()
    }
}
