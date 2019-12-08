//
//  QuestionsViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ListeningViewModelDelegate: class {
    func audioFetched()
    func questionsDownloaded()
}

protocol ErrorDelegate: class {
    func showError(message: String)
}

class ListeningViewModel {
    
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let localDatabase: LocalDatabaseManagerProtocol
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
    private let downloadTasksGroup = DispatchGroup()
  
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, test: Test, repository: CoreDataRepository<ListeningQuestion>) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
        self.repository = repository
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public func viewModel(for index: Int)-> ListeningQuestionViewModel {
        let question = questions[index]
        let audioPath = storedAudioPaths[index]
        return ListeningQuestionViewModel(listeningQuestion: question, audioPath: audioPath)
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
        downloadTasksGroup.enter()
        storage.downloadFile(question.audioPath) { audio in
            do {
                let fileURL = self.getAudioStoredPath(id: question.id)
                try audio.write(to: fileURL)
                self.storedAudioPaths[question.orderNumber-1] = fileURL
                self.downloadTasksGroup.leave()
                print(self.fileManager.fileExists(atPath: fileURL.path))
                print("Audio downloaded and saved at \(fileURL.description)")
//                self.delegate?.audioFetched()
                self.delegate?.questionsDownloaded()
            }
            catch {
                self.errorDelegate?.showError(message: error.localizedDescription)
            }
        }
    }

    public func checkUserAnswers(userAnswers: [UserAnswer])-> Int {
        var count = 0
        for index in 0..<questions.count{
            if (questions[index].correctChoiceIndex == userAnswers[index].value) {
                count += 1
            }
        }
        return count
    }
}

