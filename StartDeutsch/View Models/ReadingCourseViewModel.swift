//
//  ReadingCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine

class ReadingCourseViewModel {
    
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let test: Test
    private let remoteRepo: ReadingCourseDataSourceProtocol
    private let localRepo: ReadingCourseDataSourceProtocol
    
    // Models
    var questions: [ReadingQuestion] = []
    public var showsCorrectAnswer: Bool = false
    
    // Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    weak var userAnswerDelegate: UserAnswerDelegate?
    
    private let fileManager = FileManager.default
    private var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    
    init(firebaseStorageManager: FirebaseStorageManagerProtocol,
          remoteRepo: ReadingCourseDataSourceProtocol,
          localRepo: ReadingCourseDataSourceProtocol,
          test: Test) {
        self.test = test
        self.storage = firebaseStorageManager
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }
    
    // MARK: - Fetching Reading questions
    
    public func getQuestions() {
       localRepo.getAll(where: ["testId": test.id])
       .catch{ error-> Future<[ReadingQuestion], Error> in
           if let error = error as? CoreDataError{
               print(error.localizedDescription)
           }
           self.isNetworkCall = true
           return self.remoteRepo.getAll(where: ["testId": self.test.id])
       }
       .receive(on: DispatchQueue.main)
       .sink(receiveCompletion: { [weak self] result in
           guard let self = self else { return }
           switch result {
           case .failure(let error):
               self.errorDelegate?.showError(message: "Network error: \(error.localizedDescription). Try later.")
           case .finished:
               self.delegate?.didDownloadData()
           }
       }, receiveValue: { [weak self] questions in
           guard let self = self else { return }
           self.questions = questions
           
           if self.isNetworkCall{
               questions.forEach{ question in
                   self.localRepo.create(item: question)
               }
           }
       }).store(in: &cancellables)
    }
    
    // MARK: - Returning Question View Model
    
    // TODO: change "url" to "path"
    public func viewModel(for index: Int)-> QuestionCellViewModel?{
        let question = questions[index]
        var viewModel: QuestionCellViewModel?
        switch question.section {
        case 1:
            viewModel = ReadingQuestionPartOneViewModel(orderNumber: question.orderNumber,
                                                        texts: question.questionTexts ?? [],
                                                        url: question.imagePath ?? "")
        case 2:
            viewModel = ReadingPartTwoViewModel(orderNumber: question.orderNumber,
                                                text: question.questionText ?? "",
                                                urls: question.answerImagePaths ?? [])
        case 3:
            viewModel = ReadingPartThreeViewModel(orderNumber: question.orderNumber,
                                                  text: question.questionText ?? "",
                                                  description: question.description ?? "",
                                                  url: question.imagePath ?? "")
        default:
            return nil
        }
        return viewModel
    }
    
    // MARK: - User Answers Validation
    
    public func getCorrectAnswer(for index: Int)-> Any{
        let question = questions[index]
        switch question.section {
        case 1:
            return question.correctAnswers as Any
        default:
            return question.correctChoiceIndex as Any
        }
    }
    
    public func validate(userAnswers: Dictionary<Int, Any?>){
        var count = 0
        for index in 0..<questions.count{
            let question = questions[index]
            if question.section == 1{
                guard let answers = userAnswers[index] as? Array<Bool?> else { return }
                for i in 0..<answers.count{
                    if let correctAnswers = question.correctAnswers?[i], answers[i] == correctAnswers {
                        count += 1
                    }
                }
            }
            else {
                if let answer = userAnswers[index] as? Int, answer == question.correctChoiceIndex {
                    count += 1
                }
            }
        }
        print("Result is: \(count)")
        userAnswerDelegate?.didCheckUserAnswers(result: count)
    }
}
