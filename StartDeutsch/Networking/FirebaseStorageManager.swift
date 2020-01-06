//
//  FirebaseStorageManager.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol FirebaseStorageManagerProtocol {
    func downloadFromUrl(_ url: String, completion: @escaping (Data)-> Void)
    
    // TODO: delete this function because all downloads will be held from url, not path
    func downloadFile(_ path: String, completion: @escaping (Data)-> Void)
}

class FirebaseStorageManager: FirebaseStorageManagerProtocol {
    
    var storage: Storage { return Storage.storage()}
    
    func downloadFromUrl(_ url: String, completion: @escaping (Data)-> Void){
        storage.reference(forURL: url).getData(maxSize: 2 * 1024 * 1024){ data, error in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    completion(data)
                }
            }
        }
    }
    
    func downloadFile(_ path: String, completion: @escaping (Data)-> Void) {

        storage.reference(withPath: path).getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    completion(data)
                }
            }
        }
    }
    
}
