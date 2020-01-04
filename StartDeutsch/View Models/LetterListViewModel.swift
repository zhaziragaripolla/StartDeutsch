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
    private let repository: CoreDataRepository<Letter>
    var letters: [Letter] = []
    weak var delegate: LetterListViewModelDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository: CoreDataRepository<Letter>){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
        self.repository = repository
    }
    
    public func getLetters(){
        fetchFromLocalDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        do {
            letters = try repository.getAll(where: nil)
            if letters.isEmpty {
                fetchFromRemoteDatabase()
            }
            else {
                print("fetched from Core Data")
                delegate?.didDownloadLetters()
            }
        }
        catch let error {
            //            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses/writing/letters"){ result in
            switch result {
            case .success(let response):
                self.letters = response.map({
                    return Letter(dictionary: $0.data())!
                })
                self.delegate?.didDownloadLetters()
                self.saveToLocalDatabase()
                print("fetched from Firebase")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func saveToLocalDatabase(){
        letters.forEach({
            repository.insert(item: $0)
        })
    }
    
    public func getDetailViewModel(for index: Int)-> LetterViewModel{
        let letter = letters[index]
        return LetterViewModel(title: letter.title, task: letter.task, points: letter.points, answerImagePath: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!)
    }
}
