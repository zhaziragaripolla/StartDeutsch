//
//  MockFirebaseManager.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 1/8/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
@testable import StartDeutsch

class MockFirebaseManager: FirebaseManagerProtocol {
    var sendSuccessRequest = false
    var error = NSError(domain: "Check test on failure", code: 1, userInfo: [:])
    func getDocuments(_ path: String, completion: @escaping DocumentFetchingCompletion) {
        if sendSuccessRequest {
            completion(.success([]))
        }
        else {
            completion(.failure(error))
        }
    }
}

