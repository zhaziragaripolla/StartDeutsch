//
//  ListeningCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Combine


class ListeningCourseViewModel {
    
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let test: Test
    private let remoteRepo: ListeningCourseDataSourceProtocol
    private let localRepo: ListeningCourseDataSourceProtocol
    
    // Models
    public var storedAudioPaths = [URL?](repeating: nil, count: 15)
    public var questions: [ListeningQuestion] = []
    public var showCorrectAnswerEnabled: Bool = false
    
    // Delegates
    weak var audioDelegate: ListeningViewModelDelegate?
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    weak var userAnswerDelegate: UserAnswerDelegate?
    
    private let fileManager = FileManager.default
    private var cancellables: Set<AnyCancellable> = []
    private var isNetworkCall: Bool = false
    
    init(firebaseStorageManager: FirebaseStorageManagerProtocol,
         remoteRepo: ListeningCourseDataSourceProtocol,
         localRepo: ListeningCourseDataSourceProtocol,
         test: Test) {
        self.test = test
        self.storage = firebaseStorageManager
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }

    // MARK: - Fetching Listening Questions
    
    public func getQuestions() {
        localRepo.getAll(where: ["testId": test.id])
        .catch{ error-> Future<[ListeningQuestion], Error> in
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
    
    public func viewModel(for index: Int)-> QuestionCellViewModel {
        let question = questions[index]
        
        guard question.isMultipleChoice else {
            return ListeningQuestionBinaryChoiceViewModel(question: question.questionText,
                                                          orderNumber: question.orderNumber) }
        
        return ListeningQuestionMultipleChoiceViewModel(question: question.questionText,
                                                        orderNumber: question.orderNumber,
                                                        answerChoices: question.answerChoices ?? [])
    }
    
    // MARK: - Returning Correct Answer
    
    public func getCorrectAnswer(for index: Int)-> Int{
        let question = questions[index]
        return question.correctChoiceIndex
    }
    
    // MARK: - Fetching/Saving Audio
    
    public func getAudio(for index: Int){
        let question = questions[index]
        let path = getAudioStoredPath(id: question.id)
        if fileManager.fileExists(atPath: path.path) {
            storedAudioPaths[index] = path
            audioDelegate?.didDownloadAudio(path: path)
        }
        else {
            self.downloadAudio(for: question)
        }
    }
    
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    private func getAudioStoredPath(id: String)-> URL {
        let documentDirectory = getDocumentDirectory()
        return documentDirectory.appendingPathComponent("\(id).mp3")
    }

    private func downloadAudio(for question: ListeningQuestion) {
        storage.downloadFileFromPath(question.audioPath) { response in
            switch response {
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            case .success(let data):
                do {
                    let fileURL = self.getAudioStoredPath(id: question.id)
                    try data.write(to: fileURL)
                    self.storedAudioPaths[question.orderNumber-1] = fileURL
                    print(self.fileManager.fileExists(atPath: fileURL.path))
                    print("Audio downloaded and saved at \(fileURL.description)")
                    self.audioDelegate?.didDownloadAudio(path: fileURL)
                }
                catch {
                    self.errorDelegate?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - User Answers Validation
    
    public func validate(userAnswers: [Int?]){
        var count = 0
        for index in 0..<questions.count{
            if (questions[index].correctChoiceIndex == userAnswers[index]) {
                count += 1
            }
        }
        userAnswerDelegate?.didCheckUserAnswers(result: count)
    }
}
