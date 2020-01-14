//
//  ReadingCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

struct ReadingCourseUserAnswer {
    // Not-nil only for Reading Part One questions
    var questionIndex: Int?
    var singleValue: Int?
    var arrayValue: [Bool]?
    var isAnswered: Bool = false
}


class ReadingCourseViewController: UIViewController {

    private var viewModel: ReadingCourseViewModel!
    private var userAnswers: Dictionary<Int, Any?> = [:]

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 40, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ReadingQuestionPartOneCollectionViewCell.self, forCellWithReuseIdentifier: "partOne")
        collectionView.register(ReadingQuestionPartTwoCollectionViewCell.self, forCellWithReuseIdentifier: "partTwo")
        collectionView.register(ReadingQuestionPartThreeCollectionViewCell.self, forCellWithReuseIdentifier: "partThree")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(viewModel: ReadingCourseViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCollectionView() {
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
             collectionView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = .white
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getQuestions()
    }
}

extension ReadingCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(viewModel.questions[indexPath.row].section)
        let cellViewModel = viewModel.viewModel(for: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier(for: cellViewModel!), for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.configure(with: cellViewModel!)
        }
        if let cell = cell as? ReadingQuestionCollectionViewCell{
            cell.delegate = self
            if let answer = userAnswers[indexPath.row] as? Int {
                cell.changeButtonState(for: answer)
            }
        }
        
        if let answer = userAnswers[indexPath.row] as? [Bool?] {
            if let cell = cell as? ReadingQuestionPartOneCollectionViewCell{
                cell.setUserAnswer(answer)
            }
        }
        return cell
    }
    
    private func cellIdentifier(for viewModel: QuestionCellViewModel)-> String {
        switch viewModel {
        case is ReadingQuestionPartOneViewModel:
            return "partOne"
        case is ReadingPartTwoViewModel:
            return "partTwo"
        case is ReadingPartThreeViewModel:
            return "partThree"
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-20, height: view.frame.height-100)
    }
}

extension ReadingCourseViewController: ErrorDelegate, ReadingCourseViewModelDelegate{
 
    func showError(message: String) {
        print(message)
    }
    
    func didDownloadQuestions() {
        collectionView.reloadData()
    }
    
}

extension ReadingCourseViewController: AnswerToReadingQuestionSelectable{
    
    func didSelectMultipleAnswer(cell: UICollectionViewCell, answers: [Bool?]) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        userAnswers[indexPath.row] = answers
        checkIfAllAnswersCollected()
    }

    func didSelectSingleAnswer(cell: UICollectionViewCell, answer:
    Int) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        userAnswers[indexPath.row] = answer
        checkIfAllAnswersCollected()
    }
    
    private func checkIfAllAnswersCollected(){
        if userAnswers.values.count == viewModel.questions.count {
            viewModel.checkUserAnswers(userAnswers: userAnswers)
        }
    }
    
}

extension Bool {
    var toInt: Int {
        return self ? 1 : 0
    }
}
