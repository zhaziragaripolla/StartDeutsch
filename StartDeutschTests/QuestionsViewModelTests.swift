//
//  QuestionsViewModelTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import XCTest
@testable import StartDeutsch

class QuestionsViewModelTests: XCTestCase {

    var sut: QuestionsViewModel!
    var userAnswers: [UserAnswer] = []
    var questions: [ListeningQuestion] = []
    
    override func setUp() {
        super.setUp()
        sut = QuestionsViewModel()
        userAnswers = [UserAnswer](repeating: UserAnswer(value: 0, isAnswered: true), count: 15)
        questions = [ListeningQuestion](repeating: ListeningQuestion(question: "", answer: 0, number: 1), count: 15)
    }

    override func tearDown() {
        sut = nil
        userAnswers = []
        questions = []
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


}
