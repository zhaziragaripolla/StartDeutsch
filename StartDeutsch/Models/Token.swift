//
//  Token.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct Token: Decodable{
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let scope: String
}
