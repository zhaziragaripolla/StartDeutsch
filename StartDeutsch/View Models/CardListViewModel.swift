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
    private var randomCards: [Card] = []
    public var storedImageUrls: [URL] = [] {
        didSet {
            delegate?.didDownloadData()
        }
    }
    
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
        storedImageUrls.removeAll()
        generateRandomCards()
        getImages()
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
    
    private func getImages(){
        randomCards.forEach({
            let url = getImageStoredPath(id: $0.id)
            if FileManager.default.fileExists(atPath: url.path) {
                storedImageUrls.append(url)
            }
            else {
                self.downloadImageToLocalFile(for: $0)
            }
        })
    }
    
    private func getImageStoredPath(id: String)-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory.appendingPathComponent("\(id).png")
    }
    
    private func downloadImageToLocalFile(for card: Card){
        storage.downloadFileFromUrl(card.imageUrl) { response in
            switch response {
            case .success(let data):
                do {
                    let fileUrl = self.getImageStoredPath(id: card.id)
                    try data.write(to: fileUrl)
                    self.storedImageUrls.append(fileUrl)
                }
                catch {
                    self.errorDelegate?.showError(message: error.localizedDescription)
                }
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            }
        }
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

