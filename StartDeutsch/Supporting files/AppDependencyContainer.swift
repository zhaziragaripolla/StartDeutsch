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
    func makeCourseListViewController()-> CourseListViewController {
        let viewController = CourseListViewController(viewModel: makeCourseListViewModel())
        networkManager.addDelegate(viewController)
        return viewController
        
    }
    
    func makeCourseListViewModel()-> CourseListViewModel {
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
    func makeTestListViewController(course: Course)-> TestListViewController {
        let viewController = TestListViewController(viewModel: makeTestListViewModel(course: course))
        networkManager.addDelegate(viewController)
        return viewController
    }
    
    func makeTestListViewModel(course: Course)-> TestListViewModel {
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
        let viewController = ListeningCourseViewController(viewModel: makeListeningCourseViewModel(test: test))
        networkManager.addDelegate(viewController)
        return viewController
    }
    
    func makeListeningCourseViewModel(test: Test)-> ListeningCourseViewModel {
        return ListeningCourseViewModel(firebaseStorageManager: sharedFirebaseStorageManager,
                                        remoteRepo: makeListeningCourseRemoteDataSource(),
                                        localRepo: makeListeningCourseLocalDataSource(),
                                        test: test)
    }
    
    func makeListeningCourseRemoteDataSource()-> ListeningCourseDataSourceProtocol{
        return ListeningCourseRemoteDataSource(client: sharedAPIClient)
    }
    
    func makeListeningCourseLocalDataSource()-> ListeningCourseDataSourceProtocol{
        let coreDataClient = CoreDataRepository<ListeningQuestion>()
        return ListeningCourseLocalDataSource(client: coreDataClient)
    }
    
    // MARK: - Reading
    func makeReadingCourseViewController(test: Test)-> ReadingCourseViewController {
        let viewController = ReadingCourseViewController(viewModel: makeReadingCourseViewModel(test: test))
        networkManager.addDelegate(viewController)
        return viewController
    }
    
    func makeReadingCourseViewModel(test: Test)-> ReadingCourseViewModel {
        return ReadingCourseViewModel(remoteRepo: makeReadingCourseRemoteDataSource(),
                                      localRepo: makeReadingCourseLocalDataSource(),
                                      test: test)
    }
    
    func makeReadingCourseRemoteDataSource()-> ReadingCourseDataSourceProtocol{
        return ReadingCourseRemoteDataSource(client: sharedAPIClient)
    }

    func makeReadingCourseLocalDataSource()-> ReadingCourseDataSourceProtocol{
        let coreDataClient = CoreDataRepository<ReadingQuestion>()
        return ReadingCourseLocalDataSource(client: coreDataClient)
    }
    
    
    // MARK: - Speaking
    
    func makeWordListViewController()-> WordListViewController{
        let viewModel = WordListViewModel(remoteRepo: makeWordRemoteDataSource(),
                                          localRepo: makeWordLocalDataSource())
        let viewController = WordListViewController(viewModel: viewModel)
        networkManager.addDelegate(viewController)
        return viewController
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
        let viewController = CardListViewController(viewModel: viewModel)
        networkManager.addDelegate(viewController)
        return viewController
    }
    
    func makeCardRemoteDataSource()-> CardDataSourceProtocol{
        return CardRemoteDataSource(client: sharedAPIClient)
    }

    func makeCardLocalDataSource()-> CardDataSourceProtocol{
        let coreDataClient = CoreDataRepository<Card>()
        return CardLocalDataSource(client: coreDataClient)
    }
    
}
