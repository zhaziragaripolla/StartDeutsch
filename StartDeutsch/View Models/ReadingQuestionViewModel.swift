//
//  ReadingViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ReadingQuestionViewModel: QuestionCellViewModel {
    let orderNumber: Int
    init(orderNumber: Int){
        self.orderNumber = orderNumber
    }
}

// TODO: change "url" to "path"
class ReadingQuestionPartOneViewModel: ReadingQuestionViewModel{
    var imageUrl: String
    var texts: [String]
    
    init(orderNumber: Int, texts: [String], url: String){
        self.texts = texts
        self.imageUrl = url
        super.init(orderNumber: orderNumber)
    }
}


class ReadingPartTwoViewModel: ReadingQuestionViewModel{
    var text: String
    var imageUrls: [String]
    
    init(orderNumber: Int, text: String, urls: [String]){
        self.text = text
        self.imageUrls = urls
        super.init(orderNumber: orderNumber)
    }
}

class ReadingPartThreeViewModel: ReadingQuestionViewModel{
    var text: String
    var description: String
    var imageUrl: String
    
    init(orderNumber: Int, text: String, description: String, url: String){
        self.text = text
        self.description = description
        self.imageUrl = url
        super.init(orderNumber: orderNumber)
    }
}
