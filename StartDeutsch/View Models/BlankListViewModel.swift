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
    private let repository: CoreDataRepository<Blank>
    var blanks: [Blank] = []
    weak var delegate: BlankListViewModelDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository:CoreDataRepository<Blank>){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
        self.repository = repository
    }
    
    public func getBlanks(){
        fetchFromLocalDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        do {
            blanks = try repository.getAll(where: nil)
            if blanks.isEmpty {
                fetchFromRemoteDatabase()
            }
            else {
                print("fetched from Core Data")
                delegate?.didDownloadBlanks()
            }
        }
        catch let error {
//            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses/writing/forms"){ result in
            switch result {
            case .success(let response):
                self.blanks = response.map({
                    return Blank(dictionary: $0.data())!
                })
                self.delegate?.didDownloadBlanks()
                print("fetched from Firebase")
                self.saveToLocalDatabase()
            case .failure(let error):
                print(error)
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
        return BlankViewModel(title: blank.title, url: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!, text: blank.text, answers: blank.answerTexts)
    }
    
}
