//
//  ReadingViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit


struct ReadingPartOneViewModel: QuestionCellViewModel{
    let question: ReadingQuestionEntity
    let url: URL
    
    var imageUrl: URL {
        return url
    }
    
    var texts: [String]{
        return question.questionTexts!
    }
}


struct ReadingPartTwoViewModel: QuestionCellViewModel{
    let question: ReadingQuestionEntity
    let urls: [URL]
    
    var questionText: String {
        return question.questionText!
    }
    
    var imageUrls: [URL]{
        return urls
    }
}

struct ReadingPartThreeViewModel: QuestionCellViewModel{
    let question: ReadingQuestionEntity
    let url: URL
    
    var questionText: String {
        return question.questionText!
    }
    
    var description: String{
        return question.description!
    }

    var imageUrl: URL{
        return url
    }
}
