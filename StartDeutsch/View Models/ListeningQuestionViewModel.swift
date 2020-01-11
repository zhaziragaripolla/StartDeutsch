//
//  ListeningQuestionViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/26/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class ListeningQuestionViewModel: QuestionCellViewModel {
    let orderNumber: Int
    let question: String
    
    init(question: String, orderNumber: Int){
        self.question = question
        self.orderNumber = orderNumber
    }
}

class ListeningQuestionMultipleChoiceViewModel: ListeningQuestionViewModel {
    var answerChoices: [String]
    
    init(question: String, orderNumber: Int, answerChoices: [String]){
        self.answerChoices = answerChoices
        super.init(question: question, orderNumber: orderNumber)
    }
    
}

class ListeningQuestionBinaryChoiceViewModel: ListeningQuestionViewModel  {

}
