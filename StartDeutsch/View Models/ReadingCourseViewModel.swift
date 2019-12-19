//
//  ReadingCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class ReadingCourseViewModel {
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let localDatabase: LocalDatabaseManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    private let test: Test
//    private let repository: CoreDataRepository<ListeningQuestion>
    
    // Models
    public var questions: [ListeningQuestion] = []
    
    // Delegates
    weak var delegate: ListeningViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, test: Test) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
//        self.repository = repository
    }
}
