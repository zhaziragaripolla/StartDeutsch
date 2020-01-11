//
//  ListeningCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ListeningViewModelDelegate: class {
    func didDownloadAudio(path: URL)
    func questionsDownloaded()
    func answersChecked(result: Int)
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
    
    // Models
    public var storedAudioPaths = [URL?](repeating: nil, count: 15)
    public var questions: [ListeningQuestion] = []
    
    // Delegates
    weak var delegate: ListeningViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
  
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, test: Test, repository: CoreDataRepository<ListeningQuestion>) {
        self.firebaseManager = firebaseManager
        self.test = test
        self.storage = firebaseStorageManager
        self.repository = repository
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
    }
    
    private func fetchFromLocalDatabase(){
        do {
            self.questions = try repository.getAll(where: nil)
            if questions.isEmpty {
                self.fetchFromRemoteDatabase()
            }
//            else {
//                self.delegate?.questionsDownloaded()
//            }
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
            delegate?.didDownloadAudio(path: path)
        }
        else {
            self.downloadAudio(for: question)
        }
    }

    private func fetchFromRemoteDatabase() {
        firebaseManager.getDocuments(test.documentPath.appending("/questions")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                self.questions = response.map({
                    return ListeningQuestion(dictionary: $0.data())!
                })
                self.questions.sort(by: { $0.orderNumber < $1.orderNumber })
//                self.delegate?.questionsDownloaded()
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
        storage.downloadFile(question.audioPath) { audio in
            do {
                let fileURL = self.getAudioStoredPath(id: question.id)
                try audio.write(to: fileURL)
                self.storedAudioPaths[question.orderNumber-1] = fileURL
                print(self.fileManager.fileExists(atPath: fileURL.path))
                print("Audio downloaded and saved at \(fileURL.description)")
                self.delegate?.didDownloadAudio(path: fileURL)
            }
            catch {
                self.errorDelegate?.showError(message: error.localizedDescription)
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
        delegate?.answersChecked(result: count)
    }
}

