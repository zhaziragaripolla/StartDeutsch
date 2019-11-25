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
    let firebaseManager: FirebaseManagerProtocol
    var firestore: Firestore { return Firestore.firestore() }
    var tests: [DocumentReference] = []
    
//    func getQuestionsViewModel(index: Int)-> ListeningViewModel {
//        let vm = ListeningViewModel()
//        vm.testRef = tests[index]
//        return vm
//    }
    
    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        self.firebaseManager = firebaseManager
    }
    
    func getTests(){

        firebaseManager.getDocuments(Test.tests(course: .listening)) { result in
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
