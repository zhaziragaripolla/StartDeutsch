//
//  FirebaseManager.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/24/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

typealias DocumentFetchingCompletion = (_ completion: (Result<[QueryDocumentSnapshot], Error>))-> Void

// TODO: rename later
protocol FirebaseManagerProtocol: class {
    associatedtype Reference: ReferenceType
    func getDocuments(_ reference: Reference, completion: @escaping DocumentFetchingCompletion)
}

class FirebaseManager<Reference: ReferenceType>: FirebaseManagerProtocol {
    
    var firestore: Firestore { return Firestore.firestore() }
    
    func getDocuments(_ reference: Reference, completion: @escaping DocumentFetchingCompletion) {
        firestore.collection(reference.subcollection).getDocuments { querySnapshot, error in
            if let error = error {
                // TODO: smth with error
                completion(.failure(error))
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
