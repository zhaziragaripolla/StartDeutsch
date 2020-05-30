//
//  CourseListRepository.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/24/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

protocol CourseDataSourceProtocol {
    func getAll(where parameters: Dictionary<String, Any>?)->Future<[Course], Error>
    func create(item: Course)
    func delete(item: Course)
}

// Abstract decorator for Core Data Repository
class CourseLocalDataSource: CourseDataSourceProtocol{
    
    private let client: Repository
    
    init(client: Repository){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Course], Error> {
        return client.getAll(where: parameters)
    }
    
    func create(item: Course) {
        client.insert(item: item)
    }
    
    func delete(item: Course) {
        client.delete(item: item)
    }
    
}

// Abstract Decorator for API Client
class CourseRemoteDataSource: CourseDataSourceProtocol{
    
    private let client: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: APIClientProtocol){
        self.client = client
    }
    
    func getAll(where parameters: Dictionary<String, Any>?) -> Future<[Course], Error> {
        return Future{ [unowned self] promise in
            self.getCourseResponse()
                .map{ response in return response.list}
                .sink(receiveCompletion: { result in
                    switch result{
                        case .failure(let error):
                            promise(.failure(error))
                        default: break
                    }
                }, receiveValue: { courses in
                    if courses.isEmpty {
                        promise(.failure(APIError.noData))
                    }
                    promise(.success(courses))
                }).store(in: &self.cancellables)
        }
    }
    
    func getCourseResponse()->AnyPublisher<ListResponse<Course>, Error> {
        return client.get(from: StartDeutschEndpoint.getCourse)
    }

    func create(item: Course) {
        // Logic for sending request to post a new data into remote server goes here.
    }
    
    func delete(item: Course) {
        // Logic for sending request to delete a data from remote server goes here.
    }
}

