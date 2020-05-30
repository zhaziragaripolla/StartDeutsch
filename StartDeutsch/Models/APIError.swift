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
    case noData
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

extension APIError{
    var localizedDescription: String{
        switch self {
        case .invalidResponse:
            return "Error happened while unwrapping URLResponse."
        case .noData:
            return "Server returned empty data. Try later."
        case .decoding(let detail):
            return "Error happened while decoding response: \(detail)"
        case .networking(let statusCode, let detail):
            return "Network error. Status Code: \(statusCode). Decription: \(detail)"
        }
    }
}
