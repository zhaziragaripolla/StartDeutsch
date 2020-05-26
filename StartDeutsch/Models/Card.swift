//
//  Card.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Card: Decodable {
    public let id: String
    let imageUrl: String
    let courseId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course"
        case imageUrl
    }
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "imageUrl":imageUrl,
            "courseId":courseId
        ]
    }
}
