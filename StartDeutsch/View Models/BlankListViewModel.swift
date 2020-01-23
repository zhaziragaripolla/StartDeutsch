//
//  BlankListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class BlankListViewModel{
    
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    private let repository: CoreDataRepository<Blank>
    private let networkManager: NetworkManagerProtocol
    
    // Models
    var blanks: [Blank] = []
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository:CoreDataRepository<Blank>, networkManager: NetworkManagerProtocol){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
        self.repository = repository
        self.networkManager = networkManager
    }
    
    public func getBlanks(){
        fetchFromLocalDatabase()
        if blanks.isEmpty {
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
            blanks = try repository.getAll(where: nil)
        }
        catch {
//            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        delegate?.didStartLoading()
        firebaseManager.getDocuments("/courses/writing/forms"){ result in
            switch result {
            case .success(let response):
                self.blanks = response.map({
                    return Blank(dictionary: $0.data())!
                })
                self.delegate?.didDownloadData()
                self.delegate?.didCompleteLoading()
                print("fetched from Firebase")
                self.saveToLocalDatabase()
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            }
        }
    }
    
    private func saveToLocalDatabase(){
        blanks.forEach({
            repository.insert(item: $0)
        })
    }
    
    public func getDetailViewModel(for index: Int)-> BlankViewModel{
        let blank = blanks[index]
        return BlankViewModel(title: blank.title, imagePath: blank.imagePath, text: blank.text, answers: blank.answerTexts)
    }
    
}

extension BlankListViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            self.delegate?.networkOnline()
            if blanks.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            if blanks.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}
