//
//  CourseListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import os
import Combine

protocol ViewModelDelegate: class {
    func didDownloadData()
    func networkOffline()
    func networkOnline()
    func didStartLoading()
    func didCompleteLoading()
}

class CourseListViewModel {
    
    // Dependencies
    private let remoteRepo: CourseDataSourceProtocol
    private let localRepo: CourseDataSourceProtocol
    
    // Model
    public var courses: [Course] = []
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    
    init(remoteRepo: CourseDataSourceProtocol, localRepo: CourseDataSourceProtocol){
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }
    
    /// Fetches list of courses from local or remote repositories.
    public func getCourses(){
        localRepo.getAll(where: nil)
            .catch{ error-> Future<[Course], Error> in
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
            }, receiveValue: { [weak self] courses in
                guard let self = self else { return }
                self.courses = courses
                
                if self.isNetworkCall{
                    courses.forEach{ course in
                        self.localRepo.create(item: course)
                    }
                }
            }).store(in: &cancellables)
    }

}
