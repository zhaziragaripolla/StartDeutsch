//
//  ListeningCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import os

class ListeningCourseViewController: UIViewController {
    
    private var viewModel: ListeningCourseViewModel!
    private var audioPlayer = AVAudioPlayer()
    private var userAnswers = [Int?](repeating: nil, count: 15)
    private var finishBarButtonItem = UIBarButtonItem()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 40, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ListeningQuestionBinaryChoiceCollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        collectionView.register(ListeningQuestionMultipleChoiceCollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    fileprivate func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    init(viewModel: ListeningCourseViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        finishBarButtonItem = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(didTapFinishButton(_:)))
        finishBarButtonItem.isEnabled = false
        navigationItem.setRightBarButton(finishBarButtonItem, animated: true)
        setupCollectionView()
        viewModel.audioDelegate = self
        viewModel.errorDelegate = self
        viewModel.delegate = self
        viewModel.userAnswerDelegate = self
        viewModel.getQuestions()
    }
    
    @objc func didTapFinishButton(_ sender: UIBarButtonItem){
        viewModel.validate(userAnswers: userAnswers)
    }
 
}

extension ListeningCourseViewController: ViewModelDelegate, ListeningViewModelDelegate, ErrorDelegate, UserAnswerDelegate {
    
    func didDownloadData() {
        collectionView.reloadData()
    }
   
    func didCheckUserAnswers(result: Int) {
        finishBarButtonItem.isEnabled = false
        viewModel.showCorrectAnswerEnabled = true
        let alertController = UIAlertController(title: "Result", message: "Here is your score: \(result)", preferredStyle: .alert)
              let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        collectionView.reloadData()
    }
    
    func didDownloadAudio(path: URL) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.play()
            }
            catch{
                return
            }
        }
    }

    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ListeningCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let questionViewModel = viewModel.viewModel(for: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(for: questionViewModel), for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.configure(with: questionViewModel)
        }
        guard let questionCell = cell as? ListeningQuestionCollectionViewCell else { return cell}
        questionCell.delegate = self
        
        if let userAnswer = userAnswers[indexPath.row] {
            questionCell.resetView()
            if viewModel.showCorrectAnswerEnabled {
                questionCell.buttons.forEach({$0.isEnabled = false})
                if userAnswer == viewModel.getCorrectAnswer(for: indexPath.row) {
                    questionCell.changeButtonState(for: userAnswer, state: .correct)
                }
                else {
                    questionCell.changeButtonState(for: userAnswer, state: .mistake)
                    questionCell.changeButtonState(for: viewModel.getCorrectAnswer(for: indexPath.row), state: .correct)
                }
            }
            else {
                questionCell.changeButtonState(for: userAnswer, state: .chosen)
            }
        }
        return questionCell
    }

    private func cellIdentifier(for viewModel: QuestionCellViewModel)-> String {
        switch viewModel {
        case is ListeningQuestionBinaryChoiceViewModel:
            return "cell1"
        case is ListeningQuestionMultipleChoiceViewModel:
            return "cell2"
        default:
            os_log("Unexpected view model type")
        }
        return ""
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-20, height: view.frame.height-100)
    }
}


extension ListeningCourseViewController: ListeningQuestionDelegate {
    func didTapAudioButton(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.getAudio(for: indexPath.row)
    }
    
    func didSelectAnswer(index: Int, cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        userAnswers[indexPath.row] = index
        if !userAnswers.contains(where: { $0 == nil }) {
            finishBarButtonItem.isEnabled = true
        }
    }

}
