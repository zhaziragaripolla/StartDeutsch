//
//  CourseListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine



class CourseListViewModel {
    
    // Dependencies
    private let remoteRepo: CourseDataSourceProtocol
    private let localRepo: CourseDataSourceProtocol
    
    // Model
    public var courses: [Course] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    @Published var state: ViewModelState = .initialized
    
    init(remoteRepo: CourseDataSourceProtocol, localRepo: CourseDataSourceProtocol){
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }
    
    /// Fetches list of courses from local or remote repositories.
    public func getCourses(){
        state = .loading
        localRepo.getAll(where: nil)
            .catch{ [unowned self] error-> Future<[Course], Error> in
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
                    self.state = .error(error)
                default: break
                }
            }, receiveValue: { [weak self] courses in
                guard let self = self else { return }
                self.courses = courses
                self.state = .finish
                
                if self.isNetworkCall{
                    courses.forEach{ course in
                        self.localRepo.create(item: course)
                    }
                }
            }).store(in: &cancellables)
    }

}
