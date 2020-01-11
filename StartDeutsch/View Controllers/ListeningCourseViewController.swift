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

class ListeningCourseViewController: UIViewController {
    
    private var viewModel: ListeningCourseViewModel!
    private var audioPlayer: AVAudioPlayer?
    private var answers = [Int?](repeating: nil, count: 15)
    
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
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getQuestions()
    }
}

extension ListeningCourseViewController: ListeningViewModelDelegate, ErrorDelegate {
    func answersChecked(result: Int) {
        let alertController = UIAlertController(title: "Result", message: "Here is your score: \(result)", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func didDownloadAudio(path: URL) {
        if audioPlayer?.isPlaying ?? false{
            audioPlayer?.stop()
        }
        else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer?.play()
            }
            catch{
                print(error)
            }
        }
    }
    
    func questionsDownloaded() {
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
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
        if let cell = cell as? ListeningQuestionCollectionViewCell{
            cell.delegate = self
            if let answer = answers[indexPath.row] {
                cell.changeButtonState(for: answer)
            }
        }
        return cell
    }

    private func cellIdentifier(for viewModel: QuestionCellViewModel)-> String {
        switch viewModel {
        case is ListeningQuestionBinaryChoiceViewModel:
            return "cell1"
        case is ListeningQuestionMultipleChoiceViewModel:
            return "cell2"
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
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
        answers[indexPath.row] = index
        print(answers)
        if !answers.contains(where: { $0 == nil }) {
            viewModel.checkUserAnswers(answers: answers)
        }
    }

}
