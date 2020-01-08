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
    private let firebaseManager: FirebaseManagerProtocol
    weak var delegate: CoursesViewModelDelegate?
    private let repository: CoreDataRepository<Course>
    
    init(firebaseManager: FirebaseManagerProtocol, repository: CoreDataRepository<Course>){
        self.firebaseManager = firebaseManager
        self.repository = repository
    }
    
    public func getCourses(){
        fetchFromLocalDatabase()
        if courses.isEmpty{
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromLocalDatabase(){
        do {
            courses = try repository.getAll(where: nil)
            delegate?.reloadData()
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
                self.saveToLocalDatabase()
                self.delegate?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func saveToLocalDatabase(){
        courses.forEach({
            repository.insert(item: $0)
        })
    }

}
