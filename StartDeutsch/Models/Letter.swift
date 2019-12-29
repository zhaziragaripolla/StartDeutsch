//
//  Letter.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/29/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct Letter {
    let id: String
    let title: String
    let task: String
    let points: [String]
    let answerImagePath: String
}

extension Letter{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String,
            let task = dictionary["task"] as? String,
            let points = dictionary["points"] as? [String],
            let answerImagePath = dictionary["answerImagePath"] as? String else { return nil}
        self.init(id:id, title: title, task: task, points: points, answerImagePath: answerImagePath)
    }
}
