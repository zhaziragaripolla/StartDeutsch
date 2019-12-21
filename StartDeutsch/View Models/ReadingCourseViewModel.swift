//
//  ReadingCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ReadingCourseViewModelDelegate: class {
    func didDownloadQuestions()
}

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
    public var imageUrls: Dictionary<String, URL> = [:]
    
    // Delegates
    weak var delegate: ReadingCourseViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    private let dispatchGroup = DispatchGroup()
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, test: Test) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
//        self.repository = repository
    }
    
    public func getQuestions() {
        fetchFromRemoteDatabase()
        fetchImages()
        
        dispatchGroup.notify(queue: .main, execute: {
            self.delegate?.didDownloadQuestions()
        })
    }
    
    private func fetchImages(){
        
        for question in questionsPartOne{
            dispatchGroup.enter()
            storage.createDownloadUrl(question.imagePath){ url in
                self.imageUrls[question.imagePath] = url
                print("saved \(url) to \(question.imagePath)")
                self.dispatchGroup.leave()
            }
        }
        
        
//        for question in questionsPartOne{
//            storage.createDownloadUrl(question.imagePath){ url in
//                self.imageUrls[question.imagePath] = url
//            }
//        }
//
    }
    
    private func fetchFromRemoteDatabase(){
        dispatchGroup.enter()
        firebaseManager.getDocuments(test.documentPath.appending("/part1")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questionsPartOne = response.map({
                    return ReadingPartOneQuestion(dictionary: $0.data())!
                })
                print("Part one downloaded")
                self.dispatchGroup.leave()
                //                        self.saveToLocalDatabase()
            }
        }
        dispatchGroup.enter()
        firebaseManager.getDocuments(test.documentPath.appending("/part2")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questionsPartTwo = response.map({
                    return ReadingPartTwoQuestion(dictionary: $0.data())!
                })
                print("Part two downloaded")
                self.dispatchGroup.leave()
                //                        self.saveToLocalDatabase()
            }
        }
        dispatchGroup.enter()
        firebaseManager.getDocuments(test.documentPath.appending("/part3")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questionsPartThree = response.map({
                    return ReadingPartThreeQuestion(dictionary: $0.data())!
                })
                print("Part three downloaded")
                self.dispatchGroup.leave()
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
