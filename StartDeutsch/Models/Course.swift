//
//  Course.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/3/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ObjectConvertable {
    var dictionary: [String : Any] { get }
}


public struct Course: Decodable {
    let title: String
    let id: String
    let documentPath: String
    let aliasName: String
}

extension Course: ObjectConvertable {
    var dictionary: [String: Any] {
        return ["id" : id,
                "title" : title,
                "documentPath" : documentPath,
                "aliasName" : aliasName ]
    }
}

extension Course: DocumentSerializable {
 
    init?(dictionary: [String : Any], path: String) {
        guard let title = dictionary["title"] as? String,
            let id = dictionary["id"] as? String,
            let aliasName = dictionary["aliasName"] as? String else { return nil}
        self.init(title: title, id: id, documentPath: path, aliasName: aliasName)
    }
}
