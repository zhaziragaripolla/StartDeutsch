//
//  Test.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Test: Decodable{
    public let id: String
    let courseId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course"
    }
    
    public var dictionary: [String: Any] {
        return ["id": id,
                "courseId": courseId]
    }
}

extension Test: Equatable{
    static public func ==(lhs: Test, rhs: Test) -> Bool {
        if lhs.id == rhs.id{
            return true
        }
        return false
    }
}
