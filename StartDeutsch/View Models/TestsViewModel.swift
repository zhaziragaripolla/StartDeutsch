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
        fetchFromLocalDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        do {
            let unwrappedData = try localDatabase.fetchTests(courseId: course.id)
            if !unwrappedData.isEmpty {
                self.tests = try unwrappedData.map({
                    return try JSONDecoder().decode(Test.self, from: $0)
                })
                print("fetched from core data")
                delegate?.reloadData()
            }
            else {
                fetchFromRemoteDatabase()
            }
        }
        catch let error {
            print(error)
            
        }
        
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments(course.documentPath.appending("/tests")) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.tests = response.map({ return Test(dictionary: $0.data(), path: $0.reference.path)! })
                self.saveToLocalDatabase()
                self.delegate?.reloadData()
            }
        }
    }
    
    private func saveToLocalDatabase(){
        tests.forEach({
            localDatabase.saveTest(test: $0)
            print("saved")
        })
    }
    
    
}
