//
//  LetterListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol LetterListViewModelDelegate: class {
    func didDownloadLetters()
}

class LetterListViewModel{
    private let storage: FirebaseStorageManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    var letters: [Letter] = []
    weak var delegate: LetterListViewModelDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
    }
    
    func getLetters(){
        fetchFromRemoteDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses/writing/letters"){ result in
            switch result {
            case .success(let response):
                self.letters = response.map({
                    return Letter(dictionary: $0.data())!
                })
                self.delegate?.didDownloadLetters()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDetailViewModel(for index: Int)-> LetterViewModel{
        let letter = letters[index]
        return LetterViewModel(title: letter.title, task: letter.task, points: letter.points, answerImagePath: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!)
    }
}
