//
//  Card.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Card {
    public let id: String
    let imageUrl: String
    let courseId: String
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "imageUrl":imageUrl,
            "courseId":courseId
        ]
    }
}

extension Card{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let courseId = dictionary["courseId"] as? String,
            let imageUrl = dictionary["imagePath"] as? String else { return nil}
        self.init(id: id, imageUrl: imageUrl, courseId: courseId)
    }
}
