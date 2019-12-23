//
//  ReadingCourseViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ReadingCourseViewModelDelegate: class {
    func didDownloadQuestions()
}

class ReadingCourseViewModel {
    // Dependencies
    private let storage: FirebaseStorageManagerProtocol
    private let localDatabase: LocalDatabaseManagerProtocol
    private let firebaseManager: FirebaseManagerProtocol
    private let test: Test
//    private let repository: CoreDataRepository<ListeningQuestion>
    
    // Models
    var questions: [ReadingQuestion] = []
//    public var imageUrls = [URL](repeating: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!, count: 15)

    public var imageUrls: Dictionary<String, URL> = [:]
    // Delegates
    weak var delegate: ReadingCourseViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    private let fileManager = FileManager.default
    private let dispatchGroup = DispatchGroup()
    public var cellViewModelList: [QuestionCellViewModel] = []
    init(firebaseManager: FirebaseManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, localDatabase: LocalDatabaseManagerProtocol, test: Test) {
        self.firebaseManager = firebaseManager
        self.localDatabase = localDatabase
        self.test = test
        self.storage = firebaseStorageManager
//        self.repository = repository
        
        for i in 1...20{
            let key = "test1/reading/\(i).png"
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!
            imageUrls[key] = url
        }

    }
    
    public func getQuestions() {
        fetchFromRemoteDatabase()
//        fetchImage()
      
    }
    
    func viewModel(for index: Int)-> QuestionCellViewModel? {
        if let question = questions[index] as? ReadingPartOneQuestion {
            return viewModelPartOne(for: question)
        }
        else if let question = questions[index] as? ReadingPartTwoQuestion {
            return viewModelPartTwo(for: question)
        }
        else if let question = questions[index] as? ReadingPartThreeQuestion {
            return viewModelPartThree(for: question)
        }
        return nil
    }
    
    public func viewModels(for index: Int)-> QuestionCellViewModel{
        return cellViewModelList[index]
    }
    
    private func viewModelPartOne(for question: ReadingPartOneQuestion)-> ReadingPartOneViewModel {
        let url: URL = imageUrls[question.imagePath]!
        let viewModel = ReadingPartOneViewModel(question: question, url: url)
        return viewModel
    }
    
    private func viewModelPartTwo(for question: ReadingPartTwoQuestion)-> ReadingPartTwoViewModel{
        // TODO: fix force unwrapping
        let urls: [URL] = question.answerImagePaths.map({ return imageUrls[$0]!})
        let viewModel = ReadingPartTwoViewModel(question: question, urls: urls)
        return viewModel
    }
    
    private func viewModelPartThree(for question: ReadingPartThreeQuestion)-> ReadingPartThreeViewModel{
        // TODO: fix force unwrapping
        let url: URL = imageUrls[question.imagePath]!
        let viewModel = ReadingPartThreeViewModel(question: question, url: url)
        return viewModel
    }
    
    private func fetchImage(path: String){
        
        // TODO: fix
//        for question in questionsPartOne{
//            dispatchGroup.enter()
//            storage.createDownloadUrl(question.imagePath){ url in
//                self.imageUrls[question.imagePath] = url
//                print("saved \(url) to \(question.imagePath)")
//                self.dispatchGroup.leave()
//            }
//        }
    }
    
    private func fetchFromRemoteDatabase(){
        firebaseManager.getDocuments(test.documentPath.appending("/questions")){ result in
            switch result {
            case .failure(let error):
                self.errorDelegate?.showError(message: error.localizedDescription)
            case .success(let response):
                self.questions = response.map({
                    let section = $0.data()["section"] as? Int
                    switch section{
                    case 1:
                        return ReadingPartOneQuestion(dictionary: $0.data())!
                    case 2:
                        return ReadingPartTwoQuestion(dictionary: $0.data())!
                    case 3:
                        return ReadingPartThreeQuestion(dictionary: $0.data())!
                    default: fatalError("Unexpected reading section: \(String(describing: section))")
                    }
                })
                self.delegate?.didDownloadQuestions()
                self.questions.sort(by: { $0.orderNumber < $1.orderNumber})
            }
        }
    }
    
//    private func saveToLocalDatabase(){
//        questions.forEach({
//            repository.insert(item: $0)
//        })
//    }
    
//    public func checkUserAnswers(userAnswers: [UserAnswer]){
//        var count = 0
//        for index in 0..<questions.count{
//            if (questions[index].correctChoiceIndex == userAnswers[index].value) {
//                count += 1
//            }
//        }
//        delegate?.answersChecked(result: count)
//    }
}
