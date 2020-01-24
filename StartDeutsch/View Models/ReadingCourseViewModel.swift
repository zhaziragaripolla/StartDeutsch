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
    private let firebaseManager: FirebaseManagerProtocol
    private let test: Test
    private let repository: CoreDataRepository<ReadingQuestionEntity>
    private let networkManager: NetworkManagerProtocol
    
    // Models
    var questions: [ReadingQuestionEntity] = []
    public var showsCorrectAnswer: Bool = false
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    weak var userAnswerDelegate: UserAnswerDelegate?
    
    private let fileManager = FileManager.default
    
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, repository: CoreDataRepository<ReadingQuestionEntity>, test: Test, networkManager: NetworkManagerProtocol) {
        self.firebaseManager = firebaseManager
        self.test = test
        self.storage = firebaseStorageManager
        self.repository = repository
        self.networkManager = networkManager
    }
    
    public func getQuestions() {
        fetchFromLocalDatabase()
        if questions.isEmpty {
            if networkManager.isReachable(){
                fetchFromRemoteDatabase()
            }
            else {
                self.delegate?.networkOffline()
            }
        }
        else {
            self.questions.sort(by: { $0.orderNumber < $1.orderNumber})
            self.delegate?.didDownloadData()
        }
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
            let predicate = NSPredicate(format: "testId == %@", test.id)
            self.questions = try repository.getAll(where: predicate)
        }
        catch let error {
            errorDelegate?.showError(message: error.localizedDescription)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        delegate?.didStartLoading()
        firebaseManager.getDocuments(test.documentPath.appending("/questions")){ result in
            switch result {
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            case .success(let response):
                self.questions = response.map({
                    return ReadingQuestionEntity(dictionary: $0.data())!
                })
                self.delegate?.didCompleteLoading()
                self.delegate?.didDownloadData()
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
    
    public func getCorrectAnswer(for index: Int)-> Any{
        let question = questions[index]
        switch question.section {
        case 1:
            return question.correctAnswers as Any
        default:
            return question.correctChoiceIndex as Any
        }
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
        userAnswerDelegate?.didCheckUserAnswers(result: count)
    }
}

extension ReadingCourseViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            self.delegate?.networkOnline()
            if questions.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            if questions.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}
