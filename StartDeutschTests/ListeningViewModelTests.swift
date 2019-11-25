//
//  ListeningViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import XCTest
import FirebaseFirestore
@testable import StartDeutsch

class MockListeningViewController: ListeningViewModelDelegate, ErrorDelegate {
    
    let successExpectation = XCTestExpectation(description: "Get a call on reloading data")
    let failureExpectation = XCTestExpectation(description: "Get a call on showing error")
    
    func reloadData() {
        successExpectation.fulfill()
    }
    
    func showError(message: String) {
        failureExpectation.fulfill()
    }
    
}

class MockFirebaseManager: FirebaseManagerProtocol {
    
    var sendSuccessRequest = false
    var isGetDocumentsFunctonCalled = false
    var error = NSError(domain: "Check test on failure", code: 1, userInfo: [:])
    
    var complete: ((Result<[QueryDocumentSnapshot], Error>)->Void)!
    
    func getDocuments<Reference>(_ reference: Reference, completion: @escaping DocumentFetchingCompletion) where Reference : ReferenceType {
        
        isGetDocumentsFunctonCalled = true
        if sendSuccessRequest {
            completion(.success([]))
        }
        else {
            completion(.failure(error))
        }
    
    }
    
//    typealias Reference = Test
//
//    func getDocuments<Reference>(_ reference: Reference, completion: @escaping DocumentFetchingCompletion) {
//
//    }
}


class ListeningViewModelTests: XCTestCase {

    var sut: ListeningViewModel!
    var userAnswers: [UserAnswer] = []
    var questions: [ListeningQuestion] = []
    var vc: MockListeningViewController!
    var mockFirebaseManager: MockFirebaseManager!
    
    override func setUp() {
        super.setUp()
        mockFirebaseManager = MockFirebaseManager()
        vc = MockListeningViewController()
        sut = ListeningViewModel(delegate: vc, errorDelegate: vc, test: "courses/german/listening/test1", firebaseManager: mockFirebaseManager)
        userAnswers = [UserAnswer](repeating: UserAnswer(value: 0, isAnswered: true), count: 15)
        questions = [ListeningQuestion](repeating: ListeningQuestion(question: "", answer: 0, number: 1), count: 15)
    }

    override func tearDown() {
        sut = nil
        userAnswers = []
        questions = []
        vc = nil
        mockFirebaseManager = nil
        super.tearDown()
    }
    
    // MARK: check user answers
    
    func testViewModel_whenUserAnswersCollected_countsCorrectAnswers(){
        // given
        sut.questions = questions
        
        // when
        let correctAnswersCount = sut.checkUserAnswers(userAnswers: userAnswers)
        
        // then
        XCTAssertEqual(correctAnswersCount, 15)
    }
    
    func testViewModel_whenGetDoumentsCalled_callsFirebaseManager(){
        
        sut.getQuestions()
        
        XCTAssert(mockFirebaseManager.isGetDocumentsFunctonCalled)
    }

    func testViewModel_whenGetDocumentsOnSuccess_callsDelegate(){
        mockFirebaseManager.sendSuccessRequest = true

        sut.getQuestions()

        wait(for: [vc!.successExpectation], timeout: 1)
    }
    
    func testViewModel_whenGetDocumentsOnFailure_callsDelegate(){
        mockFirebaseManager.sendSuccessRequest = false

        sut.getQuestions()

        wait(for: [vc!.failureExpectation], timeout: 1)
    }


}
