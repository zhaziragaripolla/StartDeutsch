//
//  ReadingCourseDataSourceProtocol.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol ReadingCourseDataSourceProtocol {
    func getAll(where parameters: Dictionary<String, Any>?)->Future<[ReadingQuestion], Error>
    func create(item: ReadingQuestion)
    func delete(item: ReadingQuestion)
}

// Abstract decorator for Core Data Repository
class ReadingCourseLocalDataSource: ReadingCourseDataSourceProtocol{
    
    private let client: Repository
    
    init(client: Repository){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[ReadingQuestion], Error> {
        return client.getAll(where: parameters)
    }
    
    func create(item: ReadingQuestion) {
        client.insert(item: item)
    }
    
    func delete(item: ReadingQuestion) {
        client.delete(item: item)
    }
    
}

// Abstract Decorator for API Client
class ReadingCourseRemoteDataSource: ReadingCourseDataSourceProtocol{
    
    private let client: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: APIClientProtocol){
        self.client = client
    }
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[ReadingQuestion], Error> {
        
        guard let parameters = parameters,
            let testId = parameters["testId"] as? String else {
                print("Error: test_id parameters is undefined. Cannot make a query.")
                return Future { promise in
                    promise(.failure(APIError.noData))
                }
        }
        
        return Future{ [unowned self] promise in
            self.getReadingQuestionListResponse(testId: testId)
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
   
    func getReadingQuestionListResponse(testId: String)->AnyPublisher<ListResponse<ReadingQuestion>, Error> {
        return client.get(from: StartDeutschEndpoint.getReadingQuestion(test_id: testId))
    }
    
    func create(item: ReadingQuestion) {}
    
    func delete(item: ReadingQuestion) {}
    
}
