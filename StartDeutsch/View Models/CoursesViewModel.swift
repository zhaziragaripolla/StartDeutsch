//
//  CoursesViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol CoursesViewModelDelegate: class {
    func reloadData()
}

class CoursesViewModel {

    public var courses: [Course] = []
    private let localDatabase: LocalDatabaseManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    weak var delegate: CoursesViewModelDelegate?
    
    init(localDatabase: LocalDatabaseManagerProtocol, firebaseManager: FirebaseManagerProtocol){
        self.localDatabase = localDatabase
        self.firebaseManager = firebaseManager
    }
    
    func getCourses(){
        fetchFromRemoteDatabase()
    }
    private func fetchFromLocalDatabase(){}
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses") { result in
            switch result {
            case .success(let response):
                self.courses = response.map({ return Course(dictionary: $0.data(), path: $0.reference.path)!})
                self.delegate?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
//    func save(question: ListeningQuestion){
//        let collection = Firestore.firestore().collection("/courses/listening/tests/vUscu1si4CBOX63vopgY/questions")
//        collection.addDocument(data: question.dictionary)
//    }
    
}
