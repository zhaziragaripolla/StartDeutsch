//
//  WordListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

class WordListViewModel {
    
    // Models
    private var words: [Word] = []
    public var randomWords: [Word] = [] {
        didSet{
            delegate?.didDownloadData()
        }
    }
    
    // Dependencies
    private let remoteRepo: WordDataSourceProtocol
    private let localRepo: WordDataSourceProtocol
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    
    init(remoteRepo: WordDataSourceProtocol,
         localRepo: WordDataSourceProtocol){
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }
    
    public func getWords(){
        localRepo.getAll(where: nil)
            .catch{ error-> Future<[Word], Error> in
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
                self.reloadWords()
            }
            }, receiveValue: { [weak self] words in
                guard let self = self else { return }
                self.words = words
                
                if self.isNetworkCall{
                    words.forEach{ word in
                        self.localRepo.create(item: word)
                    }
                }
        }).store(in: &cancellables)
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
    
}
