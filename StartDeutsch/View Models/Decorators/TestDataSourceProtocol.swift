//
//  TestDataSourceProtocol.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/24/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol TestDataSourceProtocol {
    func getAll(where parameters: Dictionary<String, Any>?)->Future<[Test], Error>
    func create(item: Test)
    func delete(item: Test)
}

// Abstract decorator for Core Data Repository
class TestLocalDataSource: TestDataSourceProtocol{

    private let client: Repository
    
    init(client: Repository){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Test], Error> {
        return client.getAll(where: parameters)
    }
    
    func create(item: Test) {
        client.insert(item: item)
    }
    
    func delete(item: Test) {
        client.delete(item: item)
    }
    
}

// Abstract Decorator for API Client
class TestRemoteDataSource: TestDataSourceProtocol{
    
    private let client: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: APIClientProtocol){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Test], Error> {
        
        guard let parameters = parameters,
            let courseId = parameters["courseId"] as? String else {
                print("Error: course_id parameters is undefined. Cannot make a query.")
                return Future { promise in
                    promise(.failure(APIError.noData))
                }
        }
        
        return Future{ [unowned self] promise in
            self.getTestResponse(courseId: courseId)
                .map{ response in return response.list}
                .sink(receiveCompletion: { result in
                    switch result{
                    case .failure(let error):
                        promise(.failure(error))
                    default: break
                    }
                }, receiveValue: { tests in
                    if tests.isEmpty {
                        promise(.failure(APIError.noData))
                    }
                    promise(.success(tests))
                }).store(in: &self.cancellables)
        }
    }
    
    func getTestResponse(courseId: String)->AnyPublisher<ListResponse<Test>, Error> {
        return client.get(from: StartDeutschEndpoint.getTest(course_id: courseId))
    }

    func create(item: Test) {
        // Logic for sending request to post a new data into remote server goes here.
    }
    
    func delete(item: Test) {
        // Logic for sending request to delete a data from remote server goes here.
    }
}
