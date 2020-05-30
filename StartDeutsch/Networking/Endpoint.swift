//
//  Endpoint.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/13/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public typealias HTTPHeaders = [String:String]
public typealias HTTPBodyParameters = [String: String]
public typealias HTTPQueryParameters = [String: String]

protocol EndpointType {
    var baseUrl: URL {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var headers: HTTPHeaders? {get}
    var body: HTTPBodyParameters? {get}
    var task: HTTPQueryParameters? {get}
}

enum StartDeutschEndpoint {
    case postToken
    case getCourse
    case getTest(course_id: String)
    case getListeningQuestion(test_id: String)
    case getReadingQuestion(test_id: String)
    case getWord
    case getCard
}

extension StartDeutschEndpoint: EndpointType {
    var baseUrl: URL {
        return URL(string: "https://startdeutsch.org/")!
    }
    
    var path: String {
        switch self {
        case .getCourse:
            return "api/v1/courses/"
        case .getTest:
            return "api/v1/tests/"
        case .getListeningQuestion:
            return "api/v1/listening-questions/"
        case .getReadingQuestion:
            return "api/v1/reading-questions/"
        case .getCard:
            return "api/v1/cards/"
        case .getWord:
            return "api/v1/words/"
        case .postToken:
            return "oauth2/token/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postToken:
            return .POST
        default:
            return .GET
        }
    }

    var body: HTTPBodyParameters? {
        switch self {
        case .postToken:
            return ["grant_type":"client_credentials"]
        default:
            return nil
        }
    }
    
    var task: HTTPQueryParameters? {
        switch self{
        case .getTest(let course_id):
            return ["course_id": course_id]
        case .getListeningQuestion(let test_id):
            return ["test_id": test_id]
        case .getReadingQuestion(let test_id):
            return ["test_id": test_id]
        default:
            return nil
        }
    }

    var headers: HTTPHeaders? {
        switch self{
        case .postToken:
            return ["Content-Type" : "application/x-www-form-urlencoded",
                    "Accept" : "application/json"
            ]
        default:
            return nil
        }
    }
}
