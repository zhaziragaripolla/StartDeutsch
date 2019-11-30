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
            return LocalDatabaseManager()
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
    func makeCoursesViewController()-> CourseListViewController {
        let viewModel = makeCoursesViewModel()
        return CourseListViewController(viewModel: viewModel)
        
    }
    
    func makeCoursesViewModel()-> CoursesViewModel {
        return CoursesViewModel(localDatabase: sharedLocalDatabaseManager)
    }
    
    
    // MARK: Tests
    func makeTestsViewController(courseId: Int)-> TestListViewController {
        let viewModel = makeTestsViewModel(courseId: courseId)
        return TestListViewController(viewModel: viewModel)
    }
    
    func makeTestsViewModel(courseId: Int)-> TestsViewModel {
        return TestsViewModel(firebaseManager: sharedFirebaseManager, localDatabase: sharedLocalDatabaseManager, courseId: courseId)
    }
    
    
    // MARK: Questions
    func makeListeningCourseViewController(testId: String)-> ListeningCourseViewController {
        let viewModel = makeQuestionsViewModel(testId: testId)
        return ListeningCourseViewController(viewModel: viewModel)
    }
    
    func makeQuestionsViewModel(testId: String)-> ListeningViewModel {
        return ListeningViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, localDatabase: sharedLocalDatabaseManager, testReference: testId)
    }
  
}
