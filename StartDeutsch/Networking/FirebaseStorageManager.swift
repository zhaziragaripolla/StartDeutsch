//
//  FirebaseStorageManager.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import FirebaseStorage
import FirebaseFunctions

typealias FileDownloadingCompletion = (_ completion: (Result<Data, ErrorResponse>))-> Void

protocol FirebaseStorageManagerProtocol {
    func downloadFileFromPath(_ path: String, completion: @escaping FileDownloadingCompletion)
}

class FirebaseStorageManager: FirebaseStorageManagerProtocol {
    
    var storage: Storage { return Storage.storage()}
       
    func downloadFileFromPath(_ path: String, completion: @escaping FileDownloadingCompletion) {
        storage.reference(withPath: path).getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error as NSError?,
                let code = FunctionsErrorCode(rawValue: error.code){
                let message = error.localizedDescription
                // let details = error.userInfo[FunctionsErrorDetailsKey]
                completion(.failure(ErrorResponse(code: code.rawValue, message: message)))
            }
            if let data = data {
                completion(.success(data))
            }
        }
    }
}
