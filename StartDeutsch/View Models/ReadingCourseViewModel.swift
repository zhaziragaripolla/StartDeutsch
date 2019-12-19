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
    public var questionsPartOne: [ReadingPartOneQuestion] = []
    public var questionsPartTwo: [ReadingPartTwoQuestion] = []
    public var questionsPartThree: [ReadingPartThreeQuestion] = []
    
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
    
    public func getQuestions() {
        fetchFromRemoteDatabase()
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments(test.documentPath.appending("/part1")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questionsPartOne = response.map({
                    return ReadingPartOneQuestion(dictionary: $0.data())!
                })
                //                        self.saveToLocalDatabase()
            }
        }
        
        firebaseManager.getDocuments(test.documentPath.appending("/part2")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questionsPartTwo = response.map({
                    return ReadingPartTwoQuestion(dictionary: $0.data())!
                })
                //                        self.saveToLocalDatabase()
            }
        }
        
        firebaseManager.getDocuments(test.documentPath.appending("/part3")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questionsPartThree = response.map({
                    return ReadingPartThreeQuestion(dictionary: $0.data())!
                })
                //                        self.saveToLocalDatabase()
            }
        }
        
    }
    
//    private func saveToLocalDatabase(){
//        questions.forEach({
//            repository.insert(item: $0)
//        })
//    }
    
//    public func checkUserAnswers(userAnswers: [UserAnswer]){
//        var count = 0
//        for index in 0..<questions.count{
//            if (questions[index].correctChoiceIndex == userAnswers[index].value) {
//                count += 1
//            }
//        }
//        delegate?.answersChecked(result: count)
//    }
}
