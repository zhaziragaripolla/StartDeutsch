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
}

protocol ErrorDelegate: class {
    func showError(message: String)
}

class ListeningViewModel {
    
    var firebaseManager: FirebaseManagerProtocol
    var testReference: String
    var questions: [ListeningQuestion] = []
    var errorMessage: String = ""
    weak var delegate: ListeningViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    // TODO: delete
    var firestore: Firestore { return Firestore.firestore() }
    var storage: Storage { return Storage.storage()}
    let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    init(delegate: ListeningViewModelDelegate, errorDelegate: ErrorDelegate, test: String, firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        self.delegate = delegate
        self.firebaseManager = firebaseManager
        self.testReference = test
        self.errorDelegate = errorDelegate
    }
    
    func getQuestions() {
        print(testReference)
        firebaseManager.getDocuments(Test.questions(test: testReference)) { result in
            switch result {
            case .failure(let error):
//                self.errorMessage = error.localizedDescription
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                
                self.questions = response.map({
                    return ListeningQuestion(dictionary: $0.data())!
                })
//                for doc in response {
//                    guard let question = ListeningQuestion(dictionary: doc.data()) else { return }
//                    self.questions.append(question)
//                }
                    
                self.questions.sort(by: { $0.number < $1.number })
                self.delegate?.reloadData()
            }
            
        }

    }
    
    func getAudios(){
        // Create a reference to the file you want to download
        let testAudiosRef = storage.reference()
        let audiosRef = testAudiosRef.child("test1/question1.mp3")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        audiosRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error)
          } else {
            // Data for "images/island.jpg" is returned
//            let image = UIImage(data: data!)
            if let data = data {
                let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
                let fileURL = documentDirectory.appendingPathComponent("name.mp3")
                do {
                    try data.write(to: fileURL)
                }
                catch {
                    print(error)
                }
                
                print("saved at \(self.documentsUrl.absoluteString)")
            }
            self.delegate?.reloadData()
            print("audio downloaded")
//            print(data)
          }
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
