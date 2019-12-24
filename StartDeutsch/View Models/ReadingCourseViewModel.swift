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
    private let firebaseManager: FirebaseManagerProtocol
    private let test: Test
    private let repository: CoreDataRepository<ReadingQuestionEntity>
    
    // Models
    var questions: [ReadingQuestionEntity] = []
    public var imageUrls: Dictionary<String, URL> = [:]
    
    // Delegates
    weak var delegate: ReadingCourseViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    private let dispatchGroup = DispatchGroup()
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository: CoreDataRepository<ReadingQuestionEntity>, test: Test) {
        self.firebaseManager = firebaseManager
//        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
        self.repository = repository
        
        for i in 1...20{
            let key = "test1/reading/\(i).png"
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!
            imageUrls[key] = url
        }
    }
    
    public func getQuestions() {
        fetchFromLocalDatabase()
//        fetchImage()
    }
    
    public func viewModel(for index: Int)-> QuestionCellViewModel?{
        let question = questions[index]
        var viewModel: QuestionCellViewModel?
        switch question.section {
        case 1:
            let url: URL = imageUrls[question.imagePath!]!
            viewModel = ReadingPartOneViewModel(question: question, url: url)
        case 2:
            if let imagePaths = question.answerImagePaths{
                let urls: [URL] = imagePaths.map({
                    return imageUrls[$0]!
                })
                viewModel = ReadingPartTwoViewModel(question: question, urls: urls)
            }
        case 3:
            let url: URL = imageUrls[question.imagePath!]!
            viewModel = ReadingPartThreeViewModel(question: question, url: url)
        default:
            return nil
        }
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
    }

    private func fetchFromLocalDatabase(){
        do {
            self.questions = try repository.getAll(where: nil)
            if questions.isEmpty {
                self.fetchFromRemoteDatabase()
            }
            else {
                self.questions.sort(by: { $0.orderNumber < $1.orderNumber})
                self.delegate?.didDownloadQuestions()
            }
        }
        catch let error {
            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments(test.documentPath.appending("/questions")){ result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                self.questions = response.map({
                    return ReadingQuestionEntity(dictionary: $0.data())!
                })
                self.delegate?.didDownloadQuestions()
                self.saveToLocalDatabase()
                self.questions.sort(by: { $0.orderNumber < $1.orderNumber})
            }
        }
    }
    
    private func saveToLocalDatabase(){
        questions.forEach({
            repository.insert(item: $0)
        })
    }
    
    public func checkUserAnswers(userAnswers: Dictionary<Int, Any?>){
        var count = 0
        print("checking..")
//        for index in 0..<questions.count{
//            let question = questions[index]
//            let userAnswer = userAnswers[index]
//            switch question.section {
//            case 1:
//                if question.correctAnswers = userAnswer.value
//            default:
//                <#code#>
//            }
//        }
//        for index in 0..<questions.count{
//            if (questions[index].correctChoiceIndex == userAnswers[index].value) {
//                count += 1
//            }
//        }
//        delegate?.answersChecked(result: count)
    }
}
