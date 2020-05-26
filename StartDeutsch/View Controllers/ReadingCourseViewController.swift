//
//  ReadingCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import os

class ReadingCourseViewController: UIViewController {

    private var viewModel: ReadingCourseViewModel!
    private var userAnswers: Dictionary<Int, Any?> = [:]
    private var finishBarButtonItem = UIBarButtonItem()
    
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
        super.init(coder: coder)
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
        finishBarButtonItem = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(didTapFinishButton(_:)))
              finishBarButtonItem.isEnabled = false
        navigationItem.setRightBarButton(finishBarButtonItem, animated: true)
        view.backgroundColor = .white
        viewModel.delegate = self
        viewModel.userAnswerDelegate = self
        viewModel.errorDelegate = self
        viewModel.getQuestions()
    }
    
    @objc func didTapFinishButton(_ sender: UIBarButtonItem){
        viewModel.validate(userAnswers: userAnswers)
    }
}

extension ReadingCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.viewModel(for: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier(for: cellViewModel!), for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.configure(with: cellViewModel!)
        }
        guard let questionCell = cell as? ReadingQuestionCollectionViewCell else {return cell}
        questionCell.delegate = self
        questionCell.resetView()
        
        if let userAnswer = userAnswers[indexPath.row] as? Int,
            let correctAnswer = viewModel.getCorrectAnswer(for: indexPath.row) as? Int{
            if viewModel.showsCorrectAnswer {
                questionCell.buttons.forEach({$0.isEnabled = false})
                if userAnswer == correctAnswer {
                    questionCell.changeButtonState(for: userAnswer, state: .correct)
                }
                else {
                    questionCell.changeButtonState(for: userAnswer, state: .mistake)
                    questionCell.changeButtonState(for: correctAnswer, state: .correct)
                }
            }
            else {
                questionCell.changeButtonState(for: userAnswer, state: .chosen)
            }
        }
        
        // Custom configure with user answer for Part-1 Question
        guard let questionCellPart1 = cell as? ReadingQuestionPartOneCollectionViewCell else { return questionCell}
        
        if let userAnswer = userAnswers[indexPath.row] as? [Bool?], let correctAnswer = viewModel.getCorrectAnswer(for: indexPath.row) as? [Bool?] {
            if viewModel.showsCorrectAnswer {
                questionCellPart1.buttons.forEach({$0.isEnabled = false})
                let userAnswerInt = userAnswer.map({return $0!.toInt})
                let correctAnswerInt = correctAnswer.map({return $0!.toInt})
                questionCellPart1.setResult(userAnswer: userAnswerInt, correctAnswer: correctAnswerInt)
            }
            else {
                questionCellPart1.setUserAnswer(userAnswer, state: .chosen)
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
            os_log("Unexpected view model type")
        }
        return ""
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-20, height: view.frame.height-100)
    }
}

extension ReadingCourseViewController: ViewModelDelegate, ErrorDelegate, UserAnswerDelegate{
    
    func didCheckUserAnswers(result: Int) {
        finishBarButtonItem.isEnabled = false
        viewModel.showsCorrectAnswer = true
        let alertController = UIAlertController(title: "Result", message: "Here is your score: \(result)", preferredStyle: .alert)
              let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        collectionView.reloadData()
    }
 
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }

    func didDownloadData() {
        collectionView.reloadData()
    }
    
    func didStartLoading() {
        LoadingOverlay.shared.showOverlay(view: view)
    }
    
    func didCompleteLoading() {
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func networkOffline() {
        ConnectionFailOverlay.shared.showOverlay(view: view)
    }
    
    func networkOnline() {
        ConnectionFailOverlay.shared.hideOverlayView()
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
            finishBarButtonItem.isEnabled = true
        }
    }
    
}

extension Bool {
    var toInt: Int {
        return self ? 1 : 0
    }
}
