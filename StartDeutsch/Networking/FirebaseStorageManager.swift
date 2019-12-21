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
    func downloadFile(_ path: String, completion: @escaping (Data)-> Void)
    func createDownloadUrl(_ path: String, completion: @escaping (URL)-> Void)
}

class FirebaseStorageManager: FirebaseStorageManagerProtocol {
    
    var storage: Storage { return Storage.storage()}
    
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
    
    func createDownloadUrl(_ path: String, completion: @escaping (URL)-> Void){
        
        storage.reference().child("test1/reading/1.png").downloadURL { url, error in
            if let error = error {
                print(error)
            }
            if let url = url {
                print(url)
                completion(url)
            }
        }
    }
}
