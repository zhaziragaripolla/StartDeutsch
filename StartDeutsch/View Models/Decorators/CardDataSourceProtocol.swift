//
//  CardDataSourceProtocol.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol CardDataSourceProtocol {
    func getAll(where parameters: Dictionary<String, Any>?)->Future<[Card], Error>
    func create(item: Card)
    func delete(item: Card)
}

// Abstract decorator for Core Data Repository
class CardLocalDataSource: CardDataSourceProtocol{
    
    private let client: Repository
    
    init(client: Repository){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Card], Error> {
        return client.getAll(where: parameters)
    }
    
    func create(item: Card) {
        client.insert(item: item)
    }
    
    func delete(item: Card) {
        client.delete(item: item)
    }
    
}

// Abstract Decorator for API Client
class CardRemoteDataSource: CardDataSourceProtocol{
    
    private let client: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: APIClientProtocol){
        self.client = client
    }
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Card], Error> {
        return Future{ [unowned self] promise in
            self.getCardListResponse()
                .map{ response in return response.list}
                .sink(receiveCompletion: { result in
                    switch result{
                    case .failure(let error):
                        promise(.failure(error))
                    default: break
                    }
                }, receiveValue: { cards in
                    if cards.isEmpty {
                        promise(.failure(APIError.noData))
                    }
                    promise(.success(cards))
                }).store(in: &self.cancellables)
        }
    }
   
    func getCardListResponse()->AnyPublisher<ListResponse<Card>, Error> {
        return client.get(from: StartDeutschEndpoint.getCard)
    }
    
    func create(item: Card) {}
    
    func delete(item: Card) {}
    
}
