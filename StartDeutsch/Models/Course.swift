//
//  Course.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Course: Decodable {
    let title: String
    public let id: String
    let aliasName: String
    let description: String
}

extension Course{
    public var dictionary: [String: Any] {
        return ["id" : id,
                "title" : title,
                "aliasName" : aliasName,
                "descriptionText":description]
    }
}

extension Course: Equatable{
    static public func ==(lhs: Course, rhs: Course) -> Bool {
        if lhs.id == rhs.id{
            return true
        }
        return false
    }
}


