//
//  WordListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

class WordListViewModel {
    
    // Models
    private var words: [Word] = []
    public var randomWords: [Word] = [] {
        didSet{
            delegate?.didDownloadData()
        }
    }
    
    // Dependencies
    private let firebaseManager: FirebaseManagerProtocol
    private let repository: CoreDataRepository<Word>
    private let networkManager: NetworkManagerProtocol
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, repository: CoreDataRepository<Word>, networkManager: NetworkManagerProtocol){
        self.firebaseManager = firebaseManager
        self.repository = repository
        self.networkManager = networkManager
    }
    
    public func getWords(){
        fetchFromLocalDatabase()
        if words.isEmpty{
            if networkManager.isReachable(){
                fetchFromRemoteDatabase()
            }
            else {
                self.delegate?.networkOffline()
            }
        }
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
        delegate?.didStartLoading()
        firebaseManager.getDocuments("/courses/speaking/words"){ result in
            switch result {
            case .success(let response):
                self.words = response.map({
                    return Word(dictionary: $0.data())!
                })
                self.reloadWords()
                self.delegate?.didCompleteLoading()
                self.saveToLocalDatabase()
                print("fetched from Firebase")
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            }
        }
    }
    
    private func saveToLocalDatabase(){
        words.forEach({
            repository.insert(item: $0)
        })
    }
    
    
    private func fetchFromLocalDatabase(){
        do {
            words = try repository.getAll(where: nil)
            reloadWords()
        }
        catch {
            //            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
}

extension WordListViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            self.delegate?.networkOnline()
            if words.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            if words.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}
