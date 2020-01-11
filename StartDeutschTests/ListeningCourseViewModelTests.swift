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
//
//class MockListeningViewController: ListeningViewModelDelegate, ErrorDelegate {
//    func didDownloadAudio(path: URL) {
//        <#code#>
//    }
//
//    func questionsDownloaded() {
//        <#code#>
//    }
//
//    func answersChecked(result: Int) {
//        <#code#>
//    }
//
//    func reloadData() {}
//    func showError(message: String) {}
//}
//
//class MockFirebaseManager: FirebaseManagerProtocol {
//
//    var sendSuccessRequest = false
//    var isGetDocumentsFunctonCalled = false
//    var error = NSError(domain: "Check test on failure", code: 1, userInfo: [:])
//
////    var complete: ((Result<[QueryDocumentSnapshot], Error>)->Void)!
//
//    func getDocuments<Reference>(_ reference: Reference, completion: @escaping DocumentFetchingCompletion) where Reference : ReferenceType {
//
//        isGetDocumentsFunctonCalled = true
//        if sendSuccessRequest {
//            completion(.success([]))
//        }
//        else {
//            completion(.failure(error))
//        }
//
//    }
//
//}
//
//
//class ListeningCourseViewModelTests: XCTestCase {
//
//    var sut: ListeningCourseViewModel!
//    var userAnswers: [UserAnswer] = []
//    var questions: [ListeningQuestion] = []
//    var vc: MockListeningViewController!
//    var mockFirebaseManager: MockFirebaseManager!
//
//    override func setUp() {
//        super.setUp()
//        mockFirebaseManager = MockFirebaseManager()
//        vc = MockListeningViewController()
//        sut = ListeningViewModel(test: "", firebaseManager: mockFirebaseManager)
//        sut.errorDelegate = vc
//        sut.delegate = vc
//        userAnswers = [UserAnswer](repeating: UserAnswer(value: 0, isAnswered: true), count: 15)
//        questions = [ListeningQuestion](repeating: ListeningQuestion(question: "", answer: 0, number: 1), count: 15)
//    }
//
//    override func tearDown() {
//        sut = nil
//        userAnswers = []
//        questions = []
//        vc = nil
//        mockFirebaseManager = nil
//        super.tearDown()
//    }
//
//    // MARK: check counting user answers
//
//    func testViewModel_whenUserAnswersCollected_countsCorrectAnswers(){
//        // given
//        sut.questions = questions
//
//        // when
//        let correctAnswersCount = sut.checkUserAnswers(userAnswers: userAnswers)
//
//        // then
//        XCTAssertEqual(correctAnswersCount, 15)
//    }
//
//    // MARK: check making network call
//
//    func testViewModel_whenGetDoumentsCalled_callsFirebaseManager(){
//
//        sut.getQuestions()
//
//        XCTAssert(mockFirebaseManager.isGetDocumentsFunctonCalled)
//    }
//
//    // MARK: check delegates are not nil
//
//    func testViewModel_whenGetDocumentsOnSuccess_callsDelegate(){
//        mockFirebaseManager.sendSuccessRequest = true
//
//        sut.getQuestions()
//
//        XCTAssertNotNil(sut.delegate)
//    }
//
//    func testViewModel_whenGetDocumentsOnFailure_callsDelegate(){
//        mockFirebaseManager.sendSuccessRequest = false
//
//        sut.getQuestions()
//
//        XCTAssertNotNil(sut.errorDelegate)
//
//    }
//
//
//}
