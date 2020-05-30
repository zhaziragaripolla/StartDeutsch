//
//  TestListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

class TestListViewModel {
    
    // Dependencies
    private let remoteRepo: TestDataSourceProtocol
    private let localRepo: TestDataSourceProtocol
    public let course: Course
    
    // Model
    public var tests: [Test] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    @Published var state: ViewModelState = .initialized
    
    init(remoteRepo: TestDataSourceProtocol,
         localRepo: TestDataSourceProtocol,
         course: Course){
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
        self.course = course
    }
    
    public func getTests(){
        state = .loading
        localRepo.getAll(where: ["courseId": course.id])
            .catch{ [unowned self] error-> Future<[Test], Error> in
                if let error = error as? CoreDataError{
                    print(error.localizedDescription)
                }
                self.isNetworkCall = true
                return self.remoteRepo.getAll(where: ["courseId": self.course.id])
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.state = .error(error)
                default: break
                }
            }, receiveValue: { [weak self] tests in
                guard let self = self else { return }
                self.tests = tests
                self.state = .finish
                
                if self.isNetworkCall{
                    tests.forEach{ test in
                        self.localRepo.create(item: test)
                    }
                }
            }).store(in: &cancellables)
    }
}
