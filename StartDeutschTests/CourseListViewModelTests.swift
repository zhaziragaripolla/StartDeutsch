//
//  CourseListViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
import Combine
@testable import Start_Deutsch

class MockCourseListRepo: CourseDataSourceProtocol{
    
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

class CourseListViewModelTests: XCTestCase {
    
    var sut: CourseListViewModel!
    var localRepo: MockCourseListRepo!
    var remoteRepo: MockCourseListRepo!
    
    private var callDidDownloadData: XCTestExpectation!
    private var callErrorDelegate: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        localRepo = MockCourseListRepo()
        remoteRepo = MockCourseListRepo()
        sut = CourseListViewModel(remoteRepo: remoteRepo,
                                  localRepo: localRepo)
        sut.delegate = self
        sut.errorDelegate = self
    }
    
    override func tearDown() {
        sut = nil
        localRepo = nil
        remoteRepo = nil
        super.tearDown()
    }
    
    func testViewModel_whenGetCourses_callsLocalRepo(){
  
        // when
        sut.getCourses()
        
        // then
        XCTAssertEqual(localRepo.getAllCallCount, 1)
    }
    
    func testViewModel_whenGetCoursesFromLocalRepo_onSuccess_updateCourses(){
        // given
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        
        // when
        sut.getCourses()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
        XCTAssertEqual(localRepo.courses, sut.courses, "Returned expected models.")
    }
    
    func testViewModel_whenGetCoursesFromLocalRepo_onFailure_callRemoteRepo(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        // when
        sut.getCourses()
        
        // then
        XCTAssertEqual(remoteRepo.getAllCallCount, 1)
    }
    
    func testViewModel_whenGetCoursesFromRemoteRepo_onSuccess_updateCourses(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = false
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        
        // when
        sut.getCourses()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
        XCTAssertEqual(remoteRepo.courses, sut.courses, "Returned expected models.")
    }
    
    func testViewModel_whenGetCoursesFromRemoteRepo_onSuccess_saveCourses(){
         // given
         localRepo.returnErrorEnabled = true
         localRepo.error = CoreDataError.noData
         
         remoteRepo.returnErrorEnabled = false
         callDidDownloadData = expectation(description: "View Model Delegate is being called.")
         
         // when
         sut.getCourses()
         
         // then
         wait(for: [callDidDownloadData], timeout: 1)
         XCTAssertEqual(localRepo.createCallCount, remoteRepo.courses.count, "Saved models to Core Data.")
     }
    
    
    func testViewModel_whenGetCoursesFromRemoteRepo_onFailure_callErorDelegate(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = true
        remoteRepo.error = APIError.networking(statusCode: 500, detail: "")
        
        callErrorDelegate = expectation(description: "Error Delegate is being called.")
        
        // when
        sut.getCourses()
        
        // then
        wait(for: [callErrorDelegate], timeout: 1)
    }

}

extension CourseListViewModelTests: ViewModelDelegate, ErrorDelegate{
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
