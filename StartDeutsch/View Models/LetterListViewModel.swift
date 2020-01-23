//
//  LetterListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class LetterListViewModel{
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    private let repository: CoreDataRepository<Letter>
    private let networkManager: NetworkManagerProtocol
    
    // Models
    var letters: [Letter] = []
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository: CoreDataRepository<Letter>, networkManager: NetworkManagerProtocol){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
        self.repository = repository
        self.networkManager = networkManager
    }
    
    public func getLetters(){
        fetchFromLocalDatabase()
        if letters.isEmpty {
            if networkManager.isReachable(){
                fetchFromRemoteDatabase()
            }
            else {
                self.delegate?.networkOffline()
            }
        }
        else {
            print("fetched from Core Data")
            delegate?.didDownloadData()
        }
    }
    
    private func fetchFromLocalDatabase(){
        do {
            letters = try repository.getAll(where: nil)
        }
        catch {
            //            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        delegate?.didStartLoading()
        firebaseManager.getDocuments("/courses/writing/letters"){ result in
            switch result {
            case .success(let response):
                self.letters = response.map({
                    return Letter(dictionary: $0.data())!
                })
                self.delegate?.didCompleteLoading()
                self.delegate?.didDownloadData()
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
        letters.forEach({
            repository.insert(item: $0)
        })
    }
    
    public func getDetailViewModel(for index: Int)-> LetterViewModel{
        let letter = letters[index]
        return LetterViewModel(title: letter.title, task: letter.task, points: letter.points, answerImagePath: letter.answerImagePath)
    }
}


extension LetterListViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            self.delegate?.networkOnline()
            if letters.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            if letters.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}

