//
//  ErrorResponse.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/16/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct ErrorResponse {
    let code: Int
    let message: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String?{
        return message
    }
}
