//
//  WordDataSourceProtocol.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol WordDataSourceProtocol {
    func getAll(where parameters: Dictionary<String, Any>?)->Future<[Word], Error>
    func create(item: Word)
    func delete(item: Word)
}

// Abstract decorator for Core Data Repository
class WordLocalDataSource: WordDataSourceProtocol{
    
    private let client: Repository
    
    init(client: Repository){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Word], Error> {
        return client.getAll(where: parameters)
    }
    
    func create(item: Word) {
        client.insert(item: item)
    }
    
    func delete(item: Word) {
        client.delete(item: item)
    }
    
}

// Abstract Decorator for API Client
class WordRemoteDataSource: WordDataSourceProtocol{
    
    private let client: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: APIClientProtocol){
        self.client = client
    }
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Word], Error> {
        return Future{ [unowned self] promise in
            self.getWordListResponse()
                .map{ response in return response.list}
                .sink(receiveCompletion: { result in
                    switch result{
                    case .failure(let error):
                        promise(.failure(error))
                    default: break
                    }
                }, receiveValue: { words in
                    if words.isEmpty {
                        promise(.failure(APIError.noData))
                    }
                    promise(.success(words))
                }).store(in: &self.cancellables)
        }
    }
   
    func getWordListResponse()->AnyPublisher<ListResponse<Word>, Error> {
        return client.get(from: StartDeutschEndpoint.getWord)
    }
    
    func create(item: Word) {}
    
    func delete(item: Word) {}
    
}
