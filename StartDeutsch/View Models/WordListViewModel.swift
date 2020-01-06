//
//  WordListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol WordListViewModelDelegate: class {
    func didDownloadWords()
}

class WordListViewModel {
    private var words: [Word] = []
    public var randomWords: [Word] = [] {
        didSet{
            delegate?.didDownloadWords()
        }
    }
    private let firebaseManager: FirebaseManagerProtocol
//    private let repository: CoreDataRepository<Word>
    weak var delegate: WordListViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol){
        self.firebaseManager = firebaseManager
//        self.repository = repository
    }
    
    public func getWords(){
        fetchFromRemoteDatabase()
    }
    
    public func reloadWords(){
        randomWords.removeAll()
        generateRandomWords()
    }
    
    private func generateRandomWords(){
        while (randomWords.count<6){
            guard let word = words.randomElement() else { return }
            
            // adding only unique elements
            if !randomWords.contains(where: { word.id == $0.id}){
                randomWords.append(word)
            }
        }
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses/speaking/words"){ result in
            switch result {
            case .success(let response):
                self.words = response.map({
                    return Word(dictionary: $0.data())!
                })
                self.generateRandomWords()
                self.delegate?.didDownloadWords()
//                self.saveToLocalDatabase()
                print("fetched from Firebase")
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
//    private func saveToLocalDatabase(){
//        words.forEach({
//            repository.insert(item: $0)
//        })
//    }
    
    
//    private func fetchFromLocalDatabase(){
//        do {
//            letters = try repository.getAll(where: nil)
//            if letters.isEmpty {
//                fetchFromRemoteDatabase()
//            }
//            else {
//                print("fetched from Core Data")
//                delegate?.didDownloadLetters()
//            }
//        }
//        catch let error {
//            //            errorDelegate?.showError(message: error.localizedDescription)
//            fetchFromRemoteDatabase()
//        }
//    }
    
}
