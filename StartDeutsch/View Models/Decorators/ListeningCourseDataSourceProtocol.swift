//
//  ListeningCourseDataSourceProtocol.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/25/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol ListeningCourseDataSourceProtocol {
    func getAll(where parameters: Dictionary<String, Any>?)->Future<[ListeningQuestion], Error>
    func create(item: ListeningQuestion)
    func delete(item: ListeningQuestion)
}

// Abstract decorator for Core Data Repository
class ListeningCourseLocalDataSource: ListeningCourseDataSourceProtocol{
    
    private let client: Repository
    
    init(client: Repository){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[ListeningQuestion], Error> {
        return client.getAll(where: parameters)
    }
    
    func create(item: ListeningQuestion) {
        client.insert(item: item)
    }
    
    func delete(item: ListeningQuestion) {
        client.delete(item: item)
    }
    
}

// Abstract Decorator for API Client
class ListeningCourseRemoteDataSource: ListeningCourseDataSourceProtocol{
    
    private let client: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: APIClientProtocol){
        self.client = client
    }
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[ListeningQuestion], Error> {
        
        guard let parameters = parameters,
            let testId = parameters["testId"] as? String else {
                print("Error: test_id parameters is undefined. Cannot make a query.")
                return Future { promise in
                    promise(.failure(APIError.noData))
                }
        }
        
        return Future{ [unowned self] promise in
            self.getListeningQuestionListResponse(testId: testId)
                .map{ response in return response.list}
                .sink(receiveCompletion: { result in
                    switch result{
                    case .failure(let error):
                        promise(.failure(error))
                    default: break
                    }
                }, receiveValue: { questions in
                    if questions.isEmpty {
                        promise(.failure(APIError.noData))
                    }
                    promise(.success(questions))
                }).store(in: &self.cancellables)
        }
    }
   
    func getListeningQuestionListResponse(testId: String)->AnyPublisher<ListResponse<ListeningQuestion>, Error> {
        return client.get(from: StartDeutschEndpoint.getListeningQuestion(test_id: testId))
    }
    
    func create(item: ListeningQuestion) {}
    
    func delete(item: ListeningQuestion) {}
    
}
