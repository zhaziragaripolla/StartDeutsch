//
//  CoursesViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import FirebaseFirestore

class InitialCourse {
    let title: String
    let courseId: Int
    
   
    init(title: String, courseId: Int) {
        self.title = title
        self.courseId = courseId
    }
}

enum Courses {
    case listening(String)
    case reading
    case writing
    case speaking
}

class CoursesViewModel {
    var firestore: Firestore { return Firestore.firestore() }
    
    let courses: [InitialCourse]
    
    var tests: [DocumentReference] = []
    let localDatabase: LocalDatabaseManagerProtocol
    
    init(localDatabase: LocalDatabaseManagerProtocol){
        let listeningCourse = InitialCourse(title: "Hören", courseId: 0)
        let readingCourse = InitialCourse(title: "Lesen", courseId: 1)
        let writingCourse = InitialCourse(title: "Schreiben", courseId: 2)
        let speakingCourse = InitialCourse(title: "Sprechen", courseId: 3)
        
        self.courses = [listeningCourse, readingCourse, writingCourse, speakingCourse]
        
        self.localDatabase = localDatabase
    }
    
    func save(question: ListeningQuestion){
        let collection = Firestore.firestore().collection("/courses/german/listening/AQKDypZXqF5hLONPYyrg/questions")
        collection.addDocument(data: question.dictionary)
    }
    
}
