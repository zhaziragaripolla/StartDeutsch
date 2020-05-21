//
//  APIError.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

enum APIError: Error{
    case invalidResponse
    case networking(statusCode: Int, detail: String)
    case decoding(detail: String)
}

extension APIError: Equatable{
    static public func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (let .networking(lhsStatusCode, _), let .networking(rhsStatusCode, _)):
          return lhsStatusCode == rhsStatusCode
        default:
          return false
        }
    }
}
