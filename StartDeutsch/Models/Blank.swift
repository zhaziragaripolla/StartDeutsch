//
//  Blank.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Blank{
    public let id: String
    let title: String
    let text: String
    let imagePath: String
    let answerTexts: [String]
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "title":title,
            "text":text,
            "imagePath":imagePath,
            "answerTexts":answerTexts
        ]
    }
}

extension Blank{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String,
            let imagePath = dictionary["imagePath"] as? String,
            let answerTexts = dictionary["answerTexts"] as? [String],
            let text = dictionary["text"] as? String else { return nil}
        self.init(id:id, title: title, text: text, imagePath: imagePath, answerTexts: answerTexts)
    }
}
