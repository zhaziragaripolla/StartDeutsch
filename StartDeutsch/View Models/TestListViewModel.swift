//
//  TestListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import os

class TestListViewModel {
    // Models
    public var tests: [Test] = []
    public let course: Course
    
    // Delegate
    weak var errorDelegate: ErrorDelegate?
    weak var delegate: ViewModelDelegate?
    
    // Dependencies
    private let firebaseManager: FirebaseManagerProtocol
    private let repository: CoreDataRepository<Test>
    private let networkManager: NetworkManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol, course: Course, repository: CoreDataRepository<Test>, networkManager: NetworkManagerProtocol) {
        self.firebaseManager = firebaseManager
        self.course = course
        self.repository = repository
        self.networkManager = networkManager
    }
    
    public func getTests(){
        fetchFromLocalDatabase()
        if tests.isEmpty{
            if !networkManager.isReachable(){
                self.delegate?.networkOffline()
            }
        }
        else {
            delegate?.didDownloadData()
        }
    }
    
    private func fetchFromLocalDatabase(){
        do {
            let predicate = NSPredicate(format: "courseId == %@", course.id)
            self.tests = try repository.getAll(where: predicate)
        }
        catch let error {
            print(error)
            fetchFromRemoteDatabase()
        }
        
    }
    
    private func fetchFromRemoteDatabase(){
        delegate?.didStartLoading()
        firebaseManager.getDocuments(course.documentPath.appending("/tests")) { result in
            switch result {
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            case .success(let response):
                self.tests = response.map({ return Test(dictionary: $0.data(), path: $0.reference.path)! })
                self.delegate?.didCompleteLoading()
                self.delegate?.didDownloadData()
                self.saveToLocalDatabase()
            }
        }
    }
    
    private func saveToLocalDatabase(){
        tests.forEach({
            repository.insert(item: $0)
            print("saved")
        })
    }
    
}

extension TestListViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            os_log("Change of intenet connection. Device is online.")
            self.delegate?.networkOnline()
            if tests.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            os_log("Change of intenet connection. Device is offline.")
            if tests.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}

