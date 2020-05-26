//
//  Letter.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/29/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Letter {
    public let id: String
    let title: String
    let task: String
    let points: [String]
    let answerImagePath: String
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "title":title,
            "task":task,
            "points":points,
            "answerImagePath":answerImagePath
        ]
    }
}
