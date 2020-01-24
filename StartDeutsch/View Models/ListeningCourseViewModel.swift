//
//  ListeningCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import os

protocol ListeningViewModelDelegate: class {
    func didDownloadAudio(path: URL)
}

protocol UserAnswerDelegate: class {
    func didCheckUserAnswers(result: Int)
}

protocol ErrorDelegate: class {
    func showError(message: String)
}

class ListeningCourseViewModel {
    
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    private let test: Test
    private let repository: CoreDataRepository<ListeningQuestion>
    private let networkManager: NetworkManagerProtocol
    
    // Models
    public var storedAudioPaths = [URL?](repeating: nil, count: 15)
    public var questions: [ListeningQuestion] = []
    public var showsCorrectAnswer: Bool = false
    
    // Delegates
    weak var audioDelegate: ListeningViewModelDelegate?
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    weak var userAnswerDelegate: UserAnswerDelegate?
    
    private let fileManager = FileManager.default
  
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, test: Test, repository: CoreDataRepository<ListeningQuestion>, networkManager: NetworkManagerProtocol) {
        self.firebaseManager = firebaseManager
        self.test = test
        self.storage = firebaseStorageManager
        self.repository = repository
        self.networkManager = networkManager
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public func viewModel(for index: Int)-> QuestionCellViewModel {
        let question = questions[index]
        if question.isMultipleChoice {
            return ListeningQuestionMultipleChoiceViewModel(question: question.questionText, orderNumber: question.orderNumber, answerChoices: question.answerChoices ?? [])
        }
        return ListeningQuestionBinaryChoiceViewModel(question: question.questionText, orderNumber: question.orderNumber)
    }
    
    public func getQuestions() {
        fetchFromLocalDatabase()
        if questions.isEmpty{
            if networkManager.isReachable(){
                fetchFromRemoteDatabase()
            }
            else {
                self.delegate?.networkOffline()
            }
        }
        else {
            delegate?.didDownloadData()
        }
    }
    
    public func getCorrectAnswer(for index: Int)-> Int{
        let question = questions[index]
        return question.correctChoiceIndex
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
    
    func getAudioStoredPath(id: String)-> URL {
        let documentDirectory = getDocumentsDirectory()
        return documentDirectory.appendingPathComponent("\(id).mp3")
    }
    
    func getAudio(for index: Int){
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

    private func fetchFromRemoteDatabase() {
        firebaseManager.getDocuments(test.documentPath.appending("/questions")) { result in
            switch result {
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
            case .success(let response):
                self.questions = response.map({
                    return ListeningQuestion(dictionary: $0.data())!
                })
                self.questions.sort(by: { $0.orderNumber < $1.orderNumber })
                self.delegate?.didDownloadData()
                self.saveToLocalDatabase()
            }
        }
    }
    
    private func saveToLocalDatabase(){
        questions.forEach({
            repository.insert(item: $0)
        })
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

    public func checkUserAnswers(answers: [Int?]){
        var count = 0
        for index in 0..<questions.count{
            if (questions[index].correctChoiceIndex == answers[index]) {
                count += 1
            }
        }
        userAnswerDelegate?.didCheckUserAnswers(result: count)
    }
}

extension ListeningCourseViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
    if isReachable {
            os_log("Change of intenet connection. Device is online.")
            self.delegate?.networkOnline()
            if questions.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            os_log("Change of intenet connection. Device is offline.")
            if questions.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}
