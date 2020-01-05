//
//  CardListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol CardListViewModelDelegate: class {
    func didDownloadCards()
}

class CardListViewModel {
    public var cards: [Card] = []
    
    private let firebaseManager: FirebaseManagerProtocol
    private let storage: FirebaseStorageManagerProtocol
    weak var delegate: CardListViewModelDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, storage: FirebaseStorageManagerProtocol){
        self.firebaseManager = firebaseManager
        self.storage = storage
        //        self.repository = repository
    }
    
    public func getCards(){
        fetchFromRemoteDatabase()
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses/writing/letters"){ result in
            switch result {
            case .success(let response):
                self.cards = response.map({
                    return Card(dictionary: $0.data())!
                })
                self.delegate?.didDownloadCards()
                //                self.saveToLocalDatabase()
                print("fetched from Firebase")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //    private func saveToLocalDatabase(){
    //        cards.forEach({
    //            repository.insert(item: $0)
    //        })
    //    }
    
    
    //    private func fetchFromLocalDatabase(){
    //        do {
    //            cards = try repository.getAll(where: nil)
    //            if cards.isEmpty {
    //                fetchFromRemoteDatabase()
    //            }
    //            else {
    //                print("fetched from Core Data")
    //                delegate?.didDownloadCards()
    //            }
    //        }
    //        catch let error {
    //            //            errorDelegate?.showError(message: error.localizedDescription)
    //            fetchFromRemoteDatabase()
    //        }
    //    }
    
    
}
