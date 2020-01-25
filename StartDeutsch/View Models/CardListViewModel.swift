//
//  CardListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

class CardListViewModel {
    // Models
    private var cards: [Card] = []
    public var randomCards: [Card] = []

    //Dependencies
    private let repository: CoreDataRepository<Card>
    private let firebaseManager: FirebaseManagerProtocol
    private let storage: FirebaseStorageManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository: CoreDataRepository<Card>, networkManager: NetworkManagerProtocol){
        self.firebaseManager = firebaseManager
        self.storage = firebaseStorageManager
        self.repository = repository
        self.networkManager = networkManager
    }
    
    public func getCards(){
        fetchFromLocalDatabase()
        if cards.isEmpty{
            if networkManager.isReachable(){
                fetchFromRemoteDatabase()
            }
            else {
                self.delegate?.networkOffline()
            }
        }
    }
    
    public func reloadImages(){
        randomCards.removeAll()
        generateRandomCards()
        delegate?.didDownloadData()
    }
    
    private func fetchFromRemoteDatabase(){
        delegate?.didStartLoading()
        firebaseManager.getDocuments("/courses/speaking/cards"){ result in
            switch result {
            case .success(let response):
                self.cards = response.map({
                    return Card(dictionary: $0.data())!
                })
                self.delegate?.didCompleteLoading()
                self.saveToLocalDatabase()
                self.reloadImages()
                print("fetched from Firebase")
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            }
        }
    }
    
    private func generateRandomCards(){
        while (randomCards.count<6){
            guard let card = cards.randomElement() else { return }
            
            // adding only unique elements
            if !randomCards.contains(where: { card.id == $0.id}){
                randomCards.append(card)
            }
        }
    }

    private func getImageStoredPath(id: String)-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory.appendingPathComponent("\(id).png")
    }
    
    private func saveToLocalDatabase(){
        cards.forEach({
            repository.insert(item: $0)
        })
    }
    
    private func fetchFromLocalDatabase(){
        do {
            cards = try repository.getAll(where: nil)
            reloadImages()
        }
        catch {
            //            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    
}

extension CardListViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            self.delegate?.networkOnline()
            if cards.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            if cards.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}

