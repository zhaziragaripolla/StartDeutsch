//
//  AppDependencyContainer.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/29/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class AppDependencyContainer {
    
    let sharedLocalDatabaseManager: LocalDatabaseManager
    let sharedFirebaseManager: FirebaseManager
    let sharedFirebaseStorageManager: FirebaseStorageManager
    
    init(){
        
        func makeLocalDatabaseManager()-> LocalDatabaseManager {
            let database = LocalDatabaseManager()
            database.initalizeStack()
            return database
        }
        
        func makeFirebaseManager()-> FirebaseManager {
            return FirebaseManager()
        }
        
        func makeFirebaseStorageManager()-> FirebaseStorageManager {
            return FirebaseStorageManager()
        }
        
        self.sharedLocalDatabaseManager = makeLocalDatabaseManager()
        self.sharedFirebaseManager = makeFirebaseManager()
        self.sharedFirebaseStorageManager = makeFirebaseStorageManager()
    }
    
    // MARK: Courses
    // TODO: rename to CourseList
    func makeCoursesViewController()-> CourseListViewController {
        let viewModel = makeCoursesViewModel()
        return CourseListViewController(viewModel: viewModel)
        
    }
    
    func makeCoursesViewModel()-> CourseListViewModel {
        let repo = CoreDataRepository<Course>()
        return CourseListViewModel(localDatabase: sharedLocalDatabaseManager, firebaseManager: sharedFirebaseManager, repository: repo)
    }
    
    
    // MARK: Tests
    func makeTestsViewController(course: Course)-> TestListViewController {
        let viewModel = makeTestsViewModel(course: course)
        return TestListViewController(viewModel: viewModel)
    }
    
    func makeTestsViewModel(course: Course)-> TestListViewModel {
        return TestListViewModel(firebaseManager: sharedFirebaseManager, localDatabase: sharedLocalDatabaseManager, course: course, repository: CoreDataRepository<Test>())
    }
    
    
    // MARK: Questions
    func makeListeningCourseViewController(test: Test)-> ListeningCourseViewController {
        let viewModel = makeQuestionsViewModel(test: test)
        return ListeningCourseViewController(viewModel: viewModel)
    }
    
    func makeQuestionsViewModel(test: Test)-> ListeningViewModel {
        return ListeningViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, localDatabase: sharedLocalDatabaseManager, test: test, repository: CoreDataRepository<ListeningQuestion>())
    }
  
}
