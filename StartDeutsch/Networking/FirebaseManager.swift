//
//  FirebaseManager.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFunctions

typealias DocumentFetchingCompletion = (_ completion: (Result<[QueryDocumentSnapshot], ErrorResponse>))-> Void

protocol FirebaseManagerProtocol: class {
    func getDocuments(_ path: String, completion: @escaping DocumentFetchingCompletion)
}

class FirebaseManager: FirebaseManagerProtocol {
    
    var firestore: Firestore { return Firestore.firestore() }
    
    func getDocuments(_ path: String, completion: @escaping DocumentFetchingCompletion) {
        firestore.collection(path).getDocuments { querySnapshot, error in
            if let error = error as NSError?,
                let code = FunctionsErrorCode(rawValue: error.code){
                let message = error.localizedDescription
                // let details = error.userInfo[FunctionsErrorDetailsKey]
                completion(.failure(ErrorResponse(code: code.rawValue, message: message)))
            }
            
            if let querySnapshot = querySnapshot {
                var results: [QueryDocumentSnapshot] = []
                for document in querySnapshot.documents {
                    results.append(document)
                }
                completion(.success(results))
            }
        }
    }
}
