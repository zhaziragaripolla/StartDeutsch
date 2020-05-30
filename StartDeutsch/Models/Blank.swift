//
//  Blank.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Blank: Decodable{
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
