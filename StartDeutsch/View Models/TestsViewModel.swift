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
    let firebaseManager = FirebaseManager<Test>()
    var firestore: Firestore { return Firestore.firestore() }
    var tests: [DocumentReference] = []
    
    func getQuestionsViewModel(index: Int)-> QuestionsViewModel {
        let vm = QuestionsViewModel()
        vm.testRef = tests[index]
        return vm
    }
    
    func getTests(){

        firebaseManager.getDocuments(.tests(course: .listening)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.tests = response.map({ return $0.reference })
                self.delegate?.reloadData()
            }
            
        }
    }
    
    
}
