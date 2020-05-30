//
//  ListResponse.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/23/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct ListResponse<T>: Decodable where T:Decodable{
    let list: [T]
    
    init(from decoder:Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var decodedValues: [T] = []
        while !container.isAtEnd {
            let value = try container.decode(T.self)
            decodedValues.append(value)
        }
        self.list = decodedValues
    }
}
