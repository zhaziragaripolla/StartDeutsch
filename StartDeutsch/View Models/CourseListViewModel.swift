//
//  CourseListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol CoursesViewModelDelegate: class {
    func reloadData()
}

class CourseListViewModel {

    public var courses: [Course] = []
    private let localDatabase: LocalDatabaseManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    weak var delegate: CoursesViewModelDelegate?
    private let repository: CoreDataRepository<Course>
    
    init(localDatabase: LocalDatabaseManagerProtocol, firebaseManager: FirebaseManagerProtocol, repository: CoreDataRepository<Course>){
        self.localDatabase = localDatabase
        self.firebaseManager = firebaseManager
        self.repository = repository
    }
    
    public func getCourses(){
        fetchFromLocalDatabase()
    }
    
    private func fetchFromLocalDatabase(){
        do {
            self.courses = try repository.getAll(where: nil)
            if courses.isEmpty{
                self.fetchFromRemoteDatabase()
            }
        }
        catch let error {
            print(error)
            fetchFromRemoteDatabase()
        }
    
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments("/courses") { result in
            switch result {
            case .success(let response):
                self.courses = response.map({ return Course(dictionary: $0.data(), path: $0.reference.path)!})
                print(self.courses)
                self.delegate?.reloadData()
                self.saveToLocalDatabase()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func saveToLocalDatabase(){
        
        courses.forEach({
//            localDatabase.saveCourse(course: $0)
            repository.insert(item: $0)
            print("saved")
        })
    }
    
    
//    func save(question: ListeningQuestion){
//        let collection = Firestore.firestore().collection("/courses/listening/tests/vUscu1si4CBOX63vopgY/questions")
//        collection.addDocument(data: question.dictionary)
//    }
    
}
