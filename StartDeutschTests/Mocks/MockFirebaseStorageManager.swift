//
//  MockFirebaseStorageManager.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

@testable import Start_Deutsch

class MockFirebaseStorageManager: FirebaseStorageManagerProtocol{
    
    var downloadFileFromPathCallCount: Int = 0
    var returnErrorEnabled: Bool = false
    var error: Error! = nil
    
    func downloadFileFromPath(_ path: String, completion: @escaping FileDownloadingCompletion) {
        downloadFileFromPathCallCount += 1
        guard returnErrorEnabled else {
             completion(.success(Data()))
            return
        }
        completion(.failure(ErrorResponse.init(code: 500, message: "")))
    }
    
}
