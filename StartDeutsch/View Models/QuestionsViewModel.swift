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

protocol QuestionsViewModelDelegate: class {
    func reloadData()
}

class QuestionsViewModel {
    var firestore: Firestore { return Firestore.firestore() }
    var storage: Storage { return Storage.storage()}
    let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    weak var delegate: QuestionsViewModelDelegate?
    
    var testRef: DocumentReference! = nil
    var questions: [ListeningQuestion] = []
    
     func getQuestions(){
            let query = testRef.collection("questions")
            firestore.collection(query.path).getDocuments(completion: { qSnap, error in
                if let snap = qSnap {
                    for doc in snap.documents {
                        if let question = ListeningQuestion(dictionary: doc.data()) {
                            self.questions.append(question)
                            print(question)
                            self.delegate?.reloadData()
                        }
                        else {
                            print("No question")
                        }
                    }
                }
                if let error = error {
                    print(error)
                }
            })
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
                FileManager.default.createFile(atPath: self.documentsUrl.relativePath, contents: data, attributes: [:])
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
    
    
    func checkUserAnswers(answerIndices: [Int]) {
        var count = 0
        for index in 0..<answerIndices.count {
            questions.forEach({ question in
//                if (question.answer.isCorrect(index)) {
//                    count += 1
//                }
            })
        }
        print(count)
    }
    
    
}
