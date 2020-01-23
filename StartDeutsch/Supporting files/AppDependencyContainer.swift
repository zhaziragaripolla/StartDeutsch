//
//  AppDependencyContainer.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/29/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class AppDependencyContainer {
    
    let sharedFirebaseManager: FirebaseManager
    let sharedFirebaseStorageManager: FirebaseStorageManager
    let networkManager: NetworkManager
    init(){
        
        func makeFirebaseManager()-> FirebaseManager {
            return FirebaseManager()
        }
        
        func makeFirebaseStorageManager()-> FirebaseStorageManager {
            return FirebaseStorageManager()
        }
        func makeNetworkManager()->NetworkManager{
            return NetworkManager([])
        }
        self.sharedFirebaseManager = makeFirebaseManager()
        self.sharedFirebaseStorageManager = makeFirebaseStorageManager()
        self.networkManager = makeNetworkManager()
    }
    
    deinit {
        networkManager.stopNotifier()
    }
    
    // MARK: Courses
    // TODO: rename to CourseList
    func makeCoursesViewController()-> CourseListViewController {
        let viewModel = makeCoursesViewModel()
        networkManager.addDelegate(viewModel)
        return CourseListViewController(viewModel: viewModel)
        
    }
    
    func makeCoursesViewModel()-> CourseListViewModel {
        let repo = CoreDataRepository<Course>()
        return CourseListViewModel(firebaseManager: sharedFirebaseManager, repository: repo, networkManager: networkManager)
    }
    
    
    // MARK: Tests
    func makeTestsViewController(course: Course)-> TestListViewController {
        let viewModel = makeTestsViewModel(course: course)
        networkManager.addDelegate(viewModel)
        return TestListViewController(viewModel: viewModel)
    }
    
    func makeTestsViewModel(course: Course)-> TestListViewModel {
        return TestListViewModel(firebaseManager: sharedFirebaseManager, course: course, repository: CoreDataRepository<Test>(), networkManager: networkManager)
    }
    
    // MARK: - Listening
    func makeListeningCourseViewController(test: Test)-> ListeningCourseViewController {
        let viewModel = makeListeningQuestionsViewModel(test: test)
        networkManager.addDelegate(viewModel)
        return ListeningCourseViewController(viewModel: viewModel)
    }
    
    func makeListeningQuestionsViewModel(test: Test)-> ListeningCourseViewModel {
        return ListeningCourseViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, test: test, repository: CoreDataRepository<ListeningQuestion>(), networkManager: networkManager)
    }
    
    // MARK: - Reading
    func makeReadingCourseViewController(test: Test)-> ReadingCourseViewController {
        let viewModel = makeReadingQuestionsViewModel(test: test)
        networkManager.addDelegate(viewModel)
        return ReadingCourseViewController(viewModel: viewModel)
    }
    
    func makeReadingQuestionsViewModel(test: Test)-> ReadingCourseViewModel {
        return ReadingCourseViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, repository: CoreDataRepository<ReadingQuestionEntity>(), test: test, networkManager: networkManager)
    }
    
    // MARK: - Writing
    func makeWritingCourseViewController()-> WritingCourseViewController {
        return WritingCourseViewController()
    }
    
    func makeBlankListViewController()-> BlankListViewController{
        let viewModel = BlankListViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, repository: CoreDataRepository<Blank>(), networkManager: networkManager)
        networkManager.addDelegate(viewModel)
        return BlankListViewController(viewModel: viewModel)
    }
    
    func makeLetterListViewController()-> LetterListViewController {
        let viewModel = LetterListViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, repository: CoreDataRepository<Letter>(), networkManager: networkManager)
        networkManager.addDelegate(viewModel)
        return LetterListViewController(viewModel: viewModel)
    }
    
    func makeBlankDetailViewController(viewModel: BlankViewModel)-> BlankViewController{
        return BlankViewController(viewModel: viewModel)
    }
    
    func makeLetterDetailViewController(viewModel: LetterViewModel)-> LetterViewController{
        return LetterViewController(viewModel: viewModel)
    }
    
    // MARK: - Speaking
    
    func makeSpeakingCourseViewController()-> SpeakingCourseViewController {
          return SpeakingCourseViewController()
      }
    
    func makeWordListViewController()-> WordListViewController{
        let viewModel = WordListViewModel(firebaseManager: sharedFirebaseManager, repository: CoreDataRepository<Word>(), networkManager: networkManager)
        networkManager.addDelegate(viewModel)
        return WordListViewController(viewModel: viewModel)
    }
    
    func makeCardListViewController()-> CardListViewController {
        let viewModel = CardListViewModel(firebaseManager: sharedFirebaseManager, firebaseStorageManager: sharedFirebaseStorageManager, repository: CoreDataRepository<Card>(), networkManager: networkManager)
        networkManager.addDelegate(viewModel)
        return CardListViewController(viewModel: viewModel)
    }
    
}
