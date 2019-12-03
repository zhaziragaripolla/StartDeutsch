//
//  TestsViewModel.swift
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

class TestsViewModel {
    
    weak var delegate: TestsViewModelDelegate?
    private let firebaseManager: FirebaseManagerProtocol
    private let localDatabase: LocalDatabaseManagerProtocol
    
    public var tests: [Test] = []
    private let course: Course

    init(firebaseManager: FirebaseManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, course: Course) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.course = course
    }
    
    public func getTests(){
        fetchFromRemoteDatabase()
    }
    
    private func fetchFromLocalDatabase(){}
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments(course.documentPath.appending("/tests")) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.tests = response.map({ return Test(dictionary: $0.data(), path: $0.reference.path)! })
                self.delegate?.reloadData()
            }
        }
    }
    
    
}
