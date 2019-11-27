//
//  Test.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum Course: String {
    case listening
    case reading
    case writing
    case speaking
}

enum Test {
    case tests(course: Course)
    case questions(test: String)
}

protocol ReferenceType {
    var baseCollection: String { get }
    var subcollection: String { get }
}

extension Test: ReferenceType {
  
    var baseCollection: String {
        return "courses/german/"
    }
    
    var subcollection: String {
        switch self {
        case .tests(let course):
            return baseCollection + course.rawValue
        case .questions(let test):
            return "\(test)/questions"
        }
    }
    
}
