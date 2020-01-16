//
//  TestListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol TestsViewModelDelegate: class {
    func reloadData()
}


class TestListViewModel {
    weak var errorDelegate: ErrorDelegate?
    weak var delegate: TestsViewModelDelegate?
    private let firebaseManager: FirebaseManagerProtocol
    private let repository: CoreDataRepository<Test>
    
    public var tests: [Test] = []
    private let course: Course

    init(firebaseManager: FirebaseManagerProtocol, course: Course, repository: CoreDataRepository<Test>) {
        self.firebaseManager = firebaseManager
        self.course = course
        self.repository = repository
    }
    
    public func getTests(){
        fetchFromLocalDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        do {
            let predicate = NSPredicate(format: "courseId == %@", course.id)
            self.tests = try repository.getAll(where: predicate)
            if tests.isEmpty{
                self.fetchFromRemoteDatabase()
            }
        }
        catch let error {
            print(error)
            fetchFromRemoteDatabase()
        }
        
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments(course.documentPath.appending("/tests")) { result in
            switch result {
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            case .success(let response):
                self.tests = response.map({ return Test(dictionary: $0.data(), path: $0.reference.path)! })
                self.saveToLocalDatabase()
                self.delegate?.reloadData()
            }
        }
    }
    
    private func saveToLocalDatabase(){
        tests.forEach({
//            localDatabase.saveTest(test: $0)
            repository.insert(item: $0)
            print("saved")
        })
    }
    
    
}
