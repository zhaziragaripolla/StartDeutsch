//
//  ManagedCourse+CoreDataClass.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/4/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCourse)
public class ManagedCourse: NSManagedObject, Encodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case aliasName
        case documentPath
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(aliasName, forKey: .aliasName)
        try container.encode(documentPath, forKey: .documentPath)
    }
}
