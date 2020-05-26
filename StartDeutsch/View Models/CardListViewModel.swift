//
//  CardListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

class CardListViewModel {
    
    // Models
    private var cards: [Card] = []
    public var randomCards: [Card] = []

    // Dependencies
    private let remoteRepo: CardDataSourceProtocol
    private let localRepo: CardDataSourceProtocol
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    
    init(remoteRepo: CardDataSourceProtocol,
         localRepo: CardDataSourceProtocol){
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }
    
    public func getCards(){
        localRepo.getAll(where: nil)
            .catch{ error-> Future<[Card], Error> in
                if let error = error as? CoreDataError{
                    print(error.localizedDescription)
                }
                self.isNetworkCall = true
                return self.remoteRepo.getAll(where: nil)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: "Network error: \(error.localizedDescription). Try later.")
            case .finished:
                self.delegate?.didDownloadData()
            }
            }, receiveValue: { [weak self] cards in
                guard let self = self else { return }
                self.cards = cards
                
                if self.isNetworkCall{
                    cards.forEach{ card in
                        self.localRepo.create(item: card)
                    }
                }
        }).store(in: &cancellables)
    }
    
    public func reloadImages(){
        randomCards.removeAll()
        generateRandomCards()
        delegate?.didDownloadData()
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

}

