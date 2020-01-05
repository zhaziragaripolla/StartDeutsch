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
    let imagePath: String
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "imagePath":imagePath
        ]
    }
}

extension Card{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let imagePath = dictionary["imagePath"] as? String else { return nil}
        self.init(id: id, imagePath: imagePath)
    }
}
