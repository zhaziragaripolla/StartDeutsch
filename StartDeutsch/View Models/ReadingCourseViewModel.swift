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
    
    // Delegates
    weak var delegate: ReadingCourseViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    private let dispatchGroup = DispatchGroup()
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository: CoreDataRepository<ReadingQuestionEntity>, test: Test) {
        self.firebaseManager = firebaseManager
        self.test = test
        self.storage = firebaseStorageManager
        self.repository = repository
    }
    
    public func getQuestions() {
        fetchFromLocalDatabase()
    }
    
    // TODO: change "url" to "path"
    public func viewModel(for index: Int)-> QuestionCellViewModel?{
        let question = questions[index]
        var viewModel: QuestionCellViewModel?
        switch question.section {
        case 1:
            viewModel = ReadingQuestionPartOneViewModel(orderNumber: question.orderNumber, texts: question.questionTexts ?? [], url: question.imagePath ?? "")
        case 2:
            viewModel = ReadingPartTwoViewModel(orderNumber: question.orderNumber, text: question.questionText ?? "", urls: question.answerImagePaths ?? [])
        case 3:
            viewModel = ReadingPartThreeViewModel(orderNumber: question.orderNumber, text: question.questionText ?? "", description: question.description ?? "", url: question.imagePath ?? "")
        default:
            return nil
        }
        return viewModel
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
        // TODO: Refactor
        var count = 0
        print("checking..")
        for index in 0..<questions.count{
            let question = questions[index]
            switch question.section {
            case 1:
                if let answers = userAnswers[index] as? Array<Bool?> {
                    for i in 0..<answers.count{
                        if answers[i] == question.correctAnswers?[i] {
                            count += 1
                        }
                    }
                }
            default:
                let answer = userAnswers[index] as? Int
                if answer == question.correctChoiceIndex {
                    count += 1
                }
            }
        }
        print("Result is: \(count)")
//        delegate?.answersChecked(result: count)
    }
}
