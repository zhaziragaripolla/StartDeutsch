//
//  ViewModelState.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/30/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

enum ViewModelState{
    case initialized
    case loading
    case error(Error)
    case finish
}

extension ViewModelState: Equatable{
    static public func ==(lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case ( .loading, .loading):
          return true
        case ( .finish, .finish):
            return true
        case ( .error, .error):
            return true
        case ( .initialized, .initialized):
            return true
        default:
          return false
        }
    }
}
