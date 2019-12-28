//
//  BlankListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol BlankListViewModelDelegate: class {
    func didDownloadBlanks()
}


class BlankListViewModel{
    private let storage: FirebaseStorageManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    var blanks: [Blank] = []
    weak var delegate: BlankListViewModelDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
    }
    
    func getBlanks(){
        fetchFromRemoteDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses/writing/forms"){ result in
            switch result {
            case .success(let response):
                self.blanks = response.map({
                    return Blank(dictionary: $0.data())!
                })
                self.delegate?.didDownloadBlanks()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDetailViewModel(for index: Int)-> BlankViewModel{
        let blank = blanks[index]
        return BlankViewModel(title: blank.title, url: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!, text: blank.text, answers: blank.answerTexts)
    }
    
}
