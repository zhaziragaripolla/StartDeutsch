//
//  ListeningCourseViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/25/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
import Combine
@testable import Start_Deutsch

class ListeningCourseViewModelTests: XCTestCase {
    
    var sut: ListeningCourseViewModel!
    var localRepo: MockListeningCourseDataSource!
    var remoteRepo: MockListeningCourseDataSource!
    var mockFirebaseStorage: MockFirebaseStorageManager!
    var test: Test!
    
    private var callDidDownloadData: XCTestExpectation!
    private var callErrorDelegate: XCTestExpectation!
    private var callDidDownloadAudio: XCTestExpectation!
    private var calldidCheckUserAnswer: XCTestExpectation!
    private var correctUserAnswerResult: XCTestExpectation!
    private var expectedUserAnswerResult: Int!
   
    override func setUp() {
        super.setUp()
        localRepo = MockListeningCourseDataSource()
        remoteRepo = MockListeningCourseDataSource()
        mockFirebaseStorage = MockFirebaseStorageManager()
        test = Test(id: "id1", courseId: "id1")
        sut = ListeningCourseViewModel(firebaseStorageManager: mockFirebaseStorage,
                                       remoteRepo: remoteRepo,
                                       localRepo: localRepo,
                                       test: test)
        sut.delegate = self
        sut.errorDelegate = self
        sut.audioDelegate = self
        sut.userAnswerDelegate = self
    }
    
    override func tearDown() {
        sut = nil
        localRepo = nil
        remoteRepo = nil
       
        mockFirebaseStorage = nil
        super.tearDown()
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
        wait(for: [callDidDownloadData], timeout: 1)
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
    
    func testViewModel_whenGetAudio_callStorage(){
        // given
        let index = 0
        sut.questions = localRepo.questions.filter{ $0.testId == test.id }
        callDidDownloadAudio = expectation(description: "Firebase Storage is called.")
        
        // when
        sut.getAudio(for: index)
        
        // then
        wait(for: [callDidDownloadAudio], timeout: 1)
        XCTAssertEqual(mockFirebaseStorage.downloadFileFromPathCallCount, 1)
    }
    
    func testViewModel_whenGetAudio_onSuccess_saveAudio(){
        // given
        let index = 0
        sut.questions = localRepo.questions
        callDidDownloadAudio = expectation(description: "Firebase Storage is called.")
        
        // when
        sut.getAudio(for: index)
        
        // then
        wait(for: [callDidDownloadAudio], timeout: 1)
        XCTAssertNotNil(sut.storedAudioPaths[index])
    }
    
    func testViewModel_whenGetAudio_onFailure_callErrorDelegate(){
        // given
        let index = 0
        sut.questions = localRepo.questions.filter{ $0.testId == test.id }
        mockFirebaseStorage.returnErrorEnabled = true
        callErrorDelegate = expectation(description: "Error Delegate is called.")
        
        // when
        sut.getAudio(for: index)
        
        // then
        wait(for: [callErrorDelegate], timeout: 1)
    }
    
    func testViewModel_whenValidateUserAnswers_callDelegate(){
        // given
        let userAnswers: [Int] = [0, 1, 2, 0, 1, 0]
        calldidCheckUserAnswer = expectation(description: "User Answer Delegate is called.")
        sut.questions = localRepo.questions.filter{ $0.testId == test.id }
        expectedUserAnswerResult = 0
        correctUserAnswerResult = expectation(description: "User Answer validation result is correct.")
        for i in 0..<sut.questions.count{
            if userAnswers[i] == sut.questions[i].correctChoiceIndex{
                expectedUserAnswerResult += 1
            }
        }
        
        // when
        sut.validate(userAnswers: userAnswers)
        
        // then
        wait(for: [calldidCheckUserAnswer, correctUserAnswerResult], timeout: 3)
    }
    
}

extension ListeningCourseViewModelTests: ViewModelDelegate, ErrorDelegate, ListeningViewModelDelegate, UserAnswerDelegate{
    func didCheckUserAnswers(result: Int) {
        calldidCheckUserAnswer.fulfill()
        if result == expectedUserAnswerResult {
            correctUserAnswerResult.fulfill()
        }
    }
    
    func didDownloadAudio(path: URL) {
        callDidDownloadAudio.fulfill()
    }
    
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
