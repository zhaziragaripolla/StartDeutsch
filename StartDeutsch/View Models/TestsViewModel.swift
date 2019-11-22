//
//  TestsViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol TestsViewModelDelegate: class {
    func reloadData()
}

class TestsViewModel {
    
    weak var delegate: TestsViewModelDelegate?
    
    var firestore: Firestore { return Firestore.firestore() }
    var tests: [DocumentReference] = []
    
    func getQuestionsViewModel(index: Int)-> QuestionsViewModel {
        let vm = QuestionsViewModel()
        vm.testRef = tests[index]
        return vm
    }
    
    
    func getTestsForCourse(index: Int) {
       
        firestore.collection("courses/german/listening").getDocuments(completion: { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                for doc in querySnapshot.documents {
                    self.tests.append(doc.reference)
                }
//                print(self.tests)
//                let vm = TestsViewModel()
//                vm.tests = self.tests
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
                
            }
            if let error = error {
                print(error)
//                completion(nil)
            }
        })
    
    }
    
    
}
