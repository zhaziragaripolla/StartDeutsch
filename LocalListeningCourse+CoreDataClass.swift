//
//  LocalListeningCourse+CoreDataClass.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LocalListeningCourse)
public class LocalListeningCourse: NSManagedObject, Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case id
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
    }
}
