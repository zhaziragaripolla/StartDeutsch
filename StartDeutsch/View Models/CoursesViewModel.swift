//
//  CoursesViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum Courses {
    case listening(String)
    case reading
    case writing
    case speaking
}

class CoursesViewModel {
    var firestore: Firestore { return Firestore.firestore() }
    
    let courses: [String] = ["Hören", "Lesen", "Schreiben", "Sprechen"]
    
    var tests: [DocumentReference] = []
    
    
    func save(question: ListeningQuestion){
        let collection = Firestore.firestore().collection("/courses/german/listening/AQKDypZXqF5hLONPYyrg/questions")
        collection.addDocument(data: question.dictionary)
    }
    
}
