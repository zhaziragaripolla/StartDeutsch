//
//  CoreDataError.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/21/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

enum CoreDataError: Error{
    case failure(description: String)
    case noData
}

extension CoreDataError{
    var localizedDescription: String{
        switch self {
        case .failure(let description):
            return description
        case .noData:
            return "Local database does not contain requested data."
        }
    }
}

extension CoreDataError: Equatable{
    static public func ==(lhs: CoreDataError, rhs: CoreDataError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData):
          return true
        case (.failure, .failure):
            return true
        default:
          return false
        }
    }
}
