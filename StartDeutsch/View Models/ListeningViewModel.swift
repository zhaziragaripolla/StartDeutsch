//
//  QuestionsViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ListeningViewModelDelegate: class {
    func reloadData()
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
    
    // Models
    public var storedAudioPaths = [URL?](repeating: nil, count: 15)
    public var questions: [ListeningQuestion] = []
    
    // Delegates
    weak var delegate: ListeningViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    private let downloadTasksGroup = DispatchGroup()
 
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, test: Test) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
    }

    public func viewModel(for index: Int)-> ListeningQuestionViewModel {
        let question = questions[index]
        let audioPath = storedAudioPaths[index]!
        return ListeningQuestionViewModel(listeningQuestion: question, audioPath: audioPath)
    }
    
    public func getQuestions() {
        fetchFromRemoteDatabase()
    }
    
    private func fetchFromRemoteDatabase() {
        firebaseManager.getDocuments(test.documentPath.appending("/questions")) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                self.questions = response.map({
                    return ListeningQuestion(dictionary: $0.data(), path: $0.reference.path)!
                })
                self.questions.sort(by: { $0.orderNumber < $1.orderNumber })
                //                self.delegate?.reloadData()
                //                self.getAudios()
                self.delegate?.questionsDownloaded()
            }
        }
    }
    
    private func fetchFromLocalDatabase(){}
    
    public func getAudios(){
        
        for question in questions {
            let documentDirectory = try! self.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            //check if exists
            
            let existingFileURL = documentDirectory.appendingPathComponent("\(question.orderNumber).mp3")
                
            if self.fileManager.fileExists(atPath: existingFileURL.path) {
                self.storedAudioPaths[question.orderNumber-1] = existingFileURL
            }
            else {
                // download new file
                self.downloadTasksGroup.enter()
                self.downloadAudio(at: question.audioPath, name: "\(question.orderNumber).mp3", index: question.orderNumber-1)
            }
        }
        
        downloadTasksGroup.notify(queue: .main) {
            self.delegate?.reloadData()
        }
    }
    
    private func downloadAudio(at path: String, name: String, index: Int) {
     
        storage.downloadFile(path) { audio in
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(name)
            do {
                try audio.write(to: fileURL)
                self.storedAudioPaths[index] = fileURL
//                if self.storedAudioPaths.count == 15 {
//                    self.delegate?.reloadData()
//                }
                self.downloadTasksGroup.leave()
            }
            catch {
                print(error)
            }
            print(self.fileManager.fileExists(atPath: fileURL.path))
            print("Audio with \(name) downloaded and saved at \(fileURL.description)")
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

