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

class TestListViewModelTests: XCTestCase {
    
    var sut: TestListViewModel!
    var localRepo: MockTestListDataSourceProtocol!
    var remoteRepo: MockTestListDataSourceProtocol!
    var course: Course!
    
    private var callDidDownloadData: XCTestExpectation!
    private var callErrorDelegate: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        localRepo = MockTestListDataSourceProtocol()
        remoteRepo = MockTestListDataSourceProtocol()
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
