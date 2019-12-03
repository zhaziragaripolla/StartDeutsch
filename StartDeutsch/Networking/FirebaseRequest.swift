//
//  FirebaseRequest.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol FilePath {
    var baseCollection: String { get }
    var subcollection: String { get }
}

enum CourseCollection: String {
    case listening
    case reading
    case writing
    case speaking
}

enum FirebaseRequest {
    case getTests(courseId: CourseCollection)
    case getQuestions(atPath: String)
}

extension FirebaseRequest: FilePath {
    var baseCollection: String {
        return "courses/german/"
    }
    
    var subcollection: String {
        switch self {
        case .getTests(let course):
            return baseCollection + course.rawValue
        case .getQuestions(let path):
            return "\(path)/questions"
        }
    }
}
