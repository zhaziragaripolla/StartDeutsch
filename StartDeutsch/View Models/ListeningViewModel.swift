//
//  QuestionsViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol ListeningViewModelDelegate: class {
    func reloadData()
    func questionsDownloaded()
}

protocol ErrorDelegate: class {
    func showError(message: String)
}

class ListeningViewModel {
    
    let storage = FirebaseStorageManager()
    var storedAudioPaths = [URL?](repeating: nil, count: 15)
    
    var firebaseManager: FirebaseManagerProtocol
    var testReference: String
    var questions: [ListeningQuestion] = []
    var errorMessage: String = ""
    weak var delegate: ListeningViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    let fileManager = FileManager.default
    
    // TODO: delete
//    var firestore: Firestore { return Firestore.firestore() }
//    var storage: Storage { return Storage.storage()}
    let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    init(test: String, firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        self.firebaseManager = firebaseManager
        self.testReference = test
    }
    
    func viewModel(for index: Int)-> ListeningQuestionViewModel {
        let question = questions[index]
        let audioPath = storedAudioPaths[index]!
        return ListeningQuestionViewModel(listeningQuestion: question, audioPath: audioPath)
    }
    
    func getQuestions() {
        
        firebaseManager.getDocuments(Test.questions(test: testReference)) { result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questions = response.map({
                    return ListeningQuestion(dictionary: $0.data())!
                })
                print(self.questions)
//                for doc in response {
//                    guard let question = ListeningQuestion(dictionary: doc.data()) else { return }
//                    self.questions.append(question)
//                }
                    
                self.questions.sort(by: { $0.number < $1.number })
//                self.delegate?.reloadData()
//                self.getAudios()
                self.delegate?.questionsDownloaded()
            }
            
        }

    }
    
    
    func getAudios(){
        
        for question in questions {
            let documentDirectory = try! self.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
            
            //check if exists
            
            let existingFileURL = documentDirectory.appendingPathComponent("\(question.number).mp3")
                
            if self.fileManager.fileExists(atPath: existingFileURL.path) {
                self.storedAudioPaths[question.number-1] = existingFileURL
                
            }
            else {
                // download new file
                self.downloadAudio(at: question.audioPath, name: "\(question.number).mp3", index: question.number-1)
            }
        }
        self.delegate?.reloadData()
    }
    
    func downloadAudio(at path: String, name: String, index: Int) {
     
        storage.downloadFile(path) { audio in
//            print(path)
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(name)
            do {
                try audio.write(to: fileURL)
                self.storedAudioPaths[index] = fileURL
                if self.storedAudioPaths.count == 15 {
                    self.delegate?.reloadData()
                }
            }
            catch {
                print(error)
            }
            print(self.fileManager.fileExists(atPath: fileURL.path))
            print("Audio with \(name) downloaded and saved at \(fileURL.description)")
        }
    }
    
    func checkUserAnswers(userAnswers: [UserAnswer])-> Int {
        var count = 0
        // TODO: refactor
        
        for index in 0..<questions.count{
            if (questions[index].answer == userAnswers[index].value) {
                count += 1
            }
        }
        return count
    }
}

class FirebaseStorageManager {
    
    var storage: Storage { return Storage.storage()}
    
    func downloadFile(_ path: String, completion: @escaping (Data)-> Void) {

        storage.reference(withPath: path).getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    completion(data)
                }
            }
        }
    }
}
