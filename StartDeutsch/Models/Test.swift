//
//  Test.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct Test {
    let id: String
    let courseId: String
    let documentPath: String
    
    var dictionary: [String: Any] {
        return ["id": id,
                "courseId": courseId,
                "documentPath": documentPath ]
    }
}

extension Test: DocumentSerializable {
    init?(dictionary: [String : Any], path: String) {
        guard let id = dictionary["id"] as? String,
            let courseId = dictionary["courseId"] as? String else { return nil}
        
        self.init(id: id, courseId: courseId, documentPath: path)
    }
}
