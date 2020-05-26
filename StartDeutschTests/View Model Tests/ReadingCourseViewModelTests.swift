//
//  ReadingCourseViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
import Combine
@testable import Start_Deutsch

class ReadingCourseViewModelTests: XCTestCase {
    
    var sut: ReadingCourseViewModel!
    var remoteRepo: MockReadingCourseDataSource!
    var localRepo: MockReadingCourseDataSource!
    var firebaseStorage: MockFirebaseStorageManager!
    var test: Test!
    
    private var callDidDownloadData: XCTestExpectation!
    private var callErrorDelegate: XCTestExpectation!
    private var calldidCheckUserAnswer: XCTestExpectation!
    private var correctUserAnswerResult: XCTestExpectation!
    private var expectedUserAnswerResult: Int!
    
    override func setUp() {
        remoteRepo = MockReadingCourseDataSource()
        localRepo = MockReadingCourseDataSource()
        firebaseStorage = MockFirebaseStorageManager()
        test = Test(id: "id1", courseId: "")
        sut = ReadingCourseViewModel(firebaseStorageManager: firebaseStorage,
                                     remoteRepo: remoteRepo,
                                     localRepo: localRepo,
                                     test: test)
        sut.delegate = self
        sut.errorDelegate = self
        sut.userAnswerDelegate = self
    }

    override func tearDown() {
        sut = nil
        remoteRepo = nil
        localRepo = nil
    }
    
    func testViewModel_whenGetTests_callsLocalRepo(){
        
        // when
        sut.getQuestions()
        
        // then
        XCTAssertEqual(localRepo.getAllCallCount, 1)
    }
    
    func testViewModel_whenGetTestsFromLocalRepo_onSuccess_updateQuestions(){
        // given
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        let expectedQuestions = localRepo.questions.filter{ $0.testId == test.id }
        
        // when
        sut.getQuestions()
        
        // then
        wait(for: [callDidDownloadData], timeout: 3)
        XCTAssertEqual(expectedQuestions, sut.questions, "Returned expected questions related to chosen test.")
    }
    
    func testViewModel_whenGetTestsFromLocalRepo_onFailure_callRemoteRepo(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        // when
        sut.getQuestions()
        
        // then
        XCTAssertEqual(remoteRepo.getAllCallCount, 1)
    }
    
    func testViewModel_whenGetTestsFromRemoteRepo_onSuccess_updateQuestions(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = false
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        
        let expectedQuestions = remoteRepo.questions.filter{ $0.testId == test.id }
        
        // when
        sut.getQuestions()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
        XCTAssertEqual(expectedQuestions, sut.questions, "Returned expected models.")
    }
    
    func testViewModel_whenGetQuestionsFromRemoteRepo_onSuccess_saveQuestions(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = false
        callDidDownloadData = expectation(description: "View Model Delegate is being called.")
        
        let expectedQuestionsCount = remoteRepo.questions.filter{ $0.testId == test.id }.count
        
        // when
        sut.getQuestions()
        
        // then
        wait(for: [callDidDownloadData], timeout: 1)
        XCTAssertEqual(localRepo.createCallCount, expectedQuestionsCount, "Saved models to Core Data.")
    }
    
    
    func testViewModel_whenGetQuestionsFromRemoteRepo_onFailure_callErrorDelegate(){
        // given
        localRepo.returnErrorEnabled = true
        localRepo.error = CoreDataError.noData
        
        remoteRepo.returnErrorEnabled = true
        remoteRepo.error = APIError.networking(statusCode: 500, detail: "")
        
        callErrorDelegate = expectation(description: "Error Delegate is being called.")
        
        // when
        sut.getQuestions()
        
        // then
        wait(for: [callErrorDelegate], timeout: 1)
    }
    
    func testViewModel_whenValidateUserAnswers_callDelegate(){
        
        // given
        calldidCheckUserAnswer = expectation(description: "User Answer Delegate is called.")
        correctUserAnswerResult = expectation(description: "User Answer validation result is correct.")
        sut.questions = localRepo.questions
        var userAnswers: Dictionary<Int, Any> = [:]
     
        // getting all correct answers and saving to userAnswers
        for i in 0..<localRepo.questions.count{
            let question = localRepo.questions[i]
            if question.section == 1 {
                userAnswers[i] = question.correctAnswers
            }
            else {
                userAnswers[i] = question.correctChoiceIndex
            }
        }
        // assuming userAnswers contain all correct answers, where key is an order number, value is answer indices:
        // = [ 0: [0,1], 1: [1,1,1], 2: 0, 3: 1, 4: 1, 5: 1]
        //        +1 +1     +1 +1 +1   +1    +1    +1    +1 = 9
        expectedUserAnswerResult = 9
        
        // when
        sut.validate(userAnswers: userAnswers)
        
        // then
        wait(for: [calldidCheckUserAnswer, correctUserAnswerResult], timeout: 1)
    }
    
}


extension ReadingCourseViewModelTests: ViewModelDelegate, ErrorDelegate, UserAnswerDelegate{
    func didDownloadData() {
        callDidDownloadData.fulfill()
    }
    
    func networkOffline() {
        
    }
    
    func networkOnline() {
        
    }
    
    func didStartLoading() {
        
    }
    
    func didCompleteLoading() {
        
    }
    
    func showError(message: String) {
        callErrorDelegate.fulfill()
    }
    
    func didCheckUserAnswers(result: Int) {
        calldidCheckUserAnswer.fulfill()
        if result == expectedUserAnswerResult {
            correctUserAnswerResult.fulfill()
        }
    }
    
}
