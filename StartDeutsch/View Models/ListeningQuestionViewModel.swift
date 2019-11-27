//
//  ListeningQuestionViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/26/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct ListeningQuestionViewModel {
    
    let listeningQuestion: ListeningQuestion
    let audioPath: URL
    
    var question: String {
        return "\(listeningQuestion.number.description). \(listeningQuestion.question)"
    }
    
    var answerChoices: [String] {
        return listeningQuestion.choices ?? []
    }
    
    var isMultipleChoice: Bool {
        return listeningQuestion.isMultipleChoice
    }
    
}