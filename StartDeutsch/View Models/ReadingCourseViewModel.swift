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
//    public var imageUrls = [URL](repeating: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!, count: 15)

    public var imageUrls: Dictionary<String, URL> = [:]
    // Delegates
    weak var delegate: ReadingCourseViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    private let dispatchGroup = DispatchGroup()
    public var cellViewModelList: [QuestionCellViewModel] = []
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, test: Test) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
//        self.repository = repository
        
        for i in 1...20{
            let key = "test1/reading/\(i).png"
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!
            imageUrls[key] = url
        }

    }
    
    public func getQuestions() {
        fetchFromRemoteDatabase()
//        fetchImage()
        

        dispatchGroup.notify(queue: .main, execute: {
            let viewModelList1 = self.questionsPartOne.map({
                self.viewModelPartOne(for: $0)
            })
            let viewModelList2 = self.questionsPartTwo.map({
                self.viewModelPartTwo(for: $0)
            })
            let viewModelList3 = self.questionsPartThree.map({
                self.viewModelPartThree(for: $0)
            })
            self.cellViewModelList = viewModelList1 + viewModelList2 + viewModelList3
            
            self.delegate?.didDownloadQuestions()
        })
    }
    
    public func viewModels(for index: Int)-> QuestionCellViewModel{
        return cellViewModelList[index]
    }
    
    private func viewModelPartOne(for question: ReadingPartOneQuestion)-> ReadingPartOneViewModel {
        let url: URL = imageUrls[question.imagePath]!
        let viewModel = ReadingPartOneViewModel(question: question, url: url)
        return viewModel
    }
    
    private func viewModelPartTwo(for question: ReadingPartTwoQuestion)-> ReadingPartTwoViewModel{
        // TODO: fix force unwrapping
        let urls: [URL] = question.answerImagePaths.map({ return imageUrls[$0]!})
        let viewModel = ReadingPartTwoViewModel(question: question, urls: urls)
        return viewModel
    }
    
    private func viewModelPartThree(for question: ReadingPartThreeQuestion)-> ReadingPartThreeViewModel{
        // TODO: fix force unwrapping
        let url: URL = imageUrls[question.imagePath]!
        let viewModel = ReadingPartThreeViewModel(question: question, url: url)
        return viewModel
    }
    
    private func fetchImage(path: String){
        
        // TODO: fix
//        for question in questionsPartOne{
//            dispatchGroup.enter()
//            storage.createDownloadUrl(question.imagePath){ url in
//                self.imageUrls[question.imagePath] = url
//                print("saved \(url) to \(question.imagePath)")
//                self.dispatchGroup.leave()
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
