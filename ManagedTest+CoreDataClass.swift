//
//  ManagedTest+CoreDataClass.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/4/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedTest)
public class ManagedTest: NSManagedObject, Encodable {
    enum CodingKeys: String, CodingKey {
        case courseId
        case id
        case documentPath
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(courseId, forKey: .courseId)
        try container.encode(id, forKey: .id)
        try container.encode(documentPath, forKey: .documentPath)
    }
}
