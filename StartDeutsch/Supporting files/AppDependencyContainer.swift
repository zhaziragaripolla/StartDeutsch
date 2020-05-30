//
//  AppDependencyContainer.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/29/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class AppDependencyContainer {
    
    let sharedAPIClient: APIClient
    let sharedFirebaseStorageManager: FirebaseStorageManager
    let networkManager: NetworkManager
    let requestBuilder: RequestBuilder
    
    init(){
        
        func makeFirebaseStorageManager()-> FirebaseStorageManager {
            return FirebaseStorageManager()
        }
        func makeNetworkManager()->NetworkManager{
            return NetworkManager([])
        }
        func makeRequestBuilder()->RequestBuilder{
            return RequestBuilder()
        }
        
        func makeAPIClient()->APIClient{
            return APIClient(requestBuilder: makeRequestBuilder())
        }
        
        self.sharedFirebaseStorageManager = makeFirebaseStorageManager()
        self.networkManager = makeNetworkManager()
        self.requestBuilder = makeRequestBuilder()
        self.sharedAPIClient = makeAPIClient()
    }
    
    deinit {
        networkManager.stopNotifier()
    }
    
    
    // MARK: Courses
    // TODO: rename to CourseList
    func makeCoursesViewController()-> CourseListViewController {
        let viewController = CourseListViewController(viewModel: makeCoursesViewModel())
        networkManager.addDelegate(viewController)
        return viewController
        
    }
    
    func makeCoursesViewModel()-> CourseListViewModel {
        return CourseListViewModel(remoteRepo: makeCourseRemoteDataSource(),
                                   localRepo: makeCourseLocalDataSource())
    }
    
    func makeCourseRemoteDataSource()->CourseDataSourceProtocol{
        return CourseRemoteDataSource(client: sharedAPIClient)
    }
    
    func makeCourseLocalDataSource()->CourseDataSourceProtocol{
        let courseCoreDataClient = CoreDataRepository<Course>()
        return CourseLocalDataSource(client: courseCoreDataClient)
    }
    
    // MARK: Tests
    func makeTestsViewController(course: Course)-> TestListViewController {
        let viewController = TestListViewController(viewModel: makeTestsViewModel(course: course))
        networkManager.addDelegate(viewController)
        return viewController
    }
    
    func makeTestsViewModel(course: Course)-> TestListViewModel {
        return TestListViewModel(remoteRepo: makeTestRemoteDataSource(),
                                 localRepo: makeTestLocalDataSource(),
                                 course: course)
    }
    
    func makeTestRemoteDataSource()->TestDataSourceProtocol{
        return TestRemoteDataSource(client: sharedAPIClient)
    }
    
    func makeTestLocalDataSource()->TestDataSourceProtocol{
        let testCoreDataClient = CoreDataRepository<Test>()
        return TestLocalDataSource(client: testCoreDataClient)
    }
    
    // MARK: - Listening
    func makeListeningCourseViewController(test: Test)-> ListeningCourseViewController {
        let viewModel = makeListeningQuestionsViewModel(test: test)
        return ListeningCourseViewController(viewModel: viewModel)
    }
    
    func makeListeningQuestionsViewModel(test: Test)-> ListeningCourseViewModel {
        return ListeningCourseViewModel(firebaseStorageManager: sharedFirebaseStorageManager,
                                        remoteRepo: makeListeningQuestionRemoteDataSource(),
                                        localRepo: makeListeningQuestionLocalDataSource(),
                                        test: test)
    }
    
    func makeListeningQuestionRemoteDataSource()-> ListeningCourseDataSourceProtocol{
        return ListeningCourseRemoteDataSource(client: sharedAPIClient)
    }
    
    func makeListeningQuestionLocalDataSource()-> ListeningCourseDataSourceProtocol{
        let coreDataClient = CoreDataRepository<ListeningQuestion>()
        return ListeningCourseLocalDataSource(client: coreDataClient)
    }
    
    // MARK: - Reading
    func makeReadingCourseViewController(test: Test)-> ReadingCourseViewController {
        let viewModel = makeReadingQuestionsViewModel(test: test)
        return ReadingCourseViewController(viewModel: viewModel)
    }
    
    func makeReadingQuestionsViewModel(test: Test)-> ReadingCourseViewModel {
        return ReadingCourseViewModel(remoteRepo: makeReadingQuestionRemoteDataSource(),
                                      localRepo: makeReadingQuestionLocalDataSource(),
                                      test: test)
    }
    
    func makeReadingQuestionRemoteDataSource()-> ReadingCourseDataSourceProtocol{
        return ReadingCourseRemoteDataSource(client: sharedAPIClient)
    }

    func makeReadingQuestionLocalDataSource()-> ReadingCourseDataSourceProtocol{
        let coreDataClient = CoreDataRepository<ReadingQuestion>()
        return ReadingCourseLocalDataSource(client: coreDataClient)
    }
    
    
    // MARK: - Speaking
    
    func makeWordListViewController()-> WordListViewController{
        let viewModel = WordListViewModel(remoteRepo: makeWordRemoteDataSource(),
                                          localRepo: makeWordLocalDataSource())
        return WordListViewController(viewModel: viewModel)
    }
    
    func makeWordRemoteDataSource()-> WordDataSourceProtocol{
        return WordRemoteDataSource(client: sharedAPIClient)
    }

    func makeWordLocalDataSource()-> WordDataSourceProtocol{
        let coreDataClient = CoreDataRepository<Word>()
        return WordLocalDataSource(client: coreDataClient)
    }
    
    func makeCardListViewController()-> CardListViewController {
        let viewModel = CardListViewModel(remoteRepo: makeCardRemoteDataSource(),
                                          localRepo: makeCardLocalDataSource())
        return CardListViewController(viewModel: viewModel)
    }
    
    func makeCardRemoteDataSource()-> CardDataSourceProtocol{
        return CardRemoteDataSource(client: sharedAPIClient)
    }

    func makeCardLocalDataSource()-> CardDataSourceProtocol{
        let coreDataClient = CoreDataRepository<Card>()
        return CardLocalDataSource(client: coreDataClient)
    }
    
}
