//
//  Word.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

public struct Word {
    public let id: String
    let theme: String
    let value: String
    
    public var dictionary: [String: Any]{
        return [
            "id":id,
            "theme":theme,
            "value":value
        ]
    }
}

extension Word{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let theme = dictionary["theme"] as? String,
            let value = dictionary["value"] as? String else { return nil}
        self.init(id: id, theme: theme, value: value)
    }
}
