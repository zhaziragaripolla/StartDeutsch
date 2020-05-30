//
//  Word.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Word: Decodable {
    public let id: String
    let courseId: String
    let theme: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course"
        case theme
        case value
    }
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "courseId":courseId,
            "theme":theme,
            "value":value
        ]
    }
}
