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
    
    private var viewModel: ListeningViewModel!
    private var userAnswers = [UserAnswer](repeating: UserAnswer(), count: 15)
    private let tableView = UITableView()
    private var audioPlayer: AVAudioPlayer?
    
    init(viewModel: ListeningViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListeningQuestionBinaryChoiceTableViewCell.self, forCellReuseIdentifier: "binaryQuestion")
        tableView.register(ListeningQuestionMultipleChoiceTableViewCell.self, forCellReuseIdentifier: "multipleQuestion")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        tableView.reloadData()
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ListeningCourseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionViewModel = viewModel.viewModel(for: indexPath.row)
        let userAnswer = userAnswers[indexPath.row]
        if questionViewModel.isMultipleChoice {
            let cell = tableView.dequeueReusableCell(withIdentifier: "multipleQuestion", for: indexPath) as! ListeningQuestionMultipleChoiceTableViewCell
            cell.configure(with: questionViewModel)
            if userAnswer.isAnswered {
                cell.changeButtonState(userAnswer.value)
            }
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "binaryQuestion", for: indexPath) as! ListeningQuestionBinaryChoiceTableViewCell
            cell.configure(with: questionViewModel)
            if userAnswer.isAnswered {
                cell.changeButtonState(userAnswer.value)
            }
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let questionViewModel = viewModel.viewModel(for: indexPath.row)
        return questionViewModel.isMultipleChoice ? 200 : 120
    }
}


extension ListeningCourseViewController: ListeningCellDelegate{
    func didSelectAnswer(_ index: Int, _ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let userAnswer = UserAnswer(value: index, isAnswered: true)
        userAnswers[indexPath.row] = userAnswer
        if !userAnswers.contains(where: { $0.isAnswered == false }) {
            viewModel.checkUserAnswers(userAnswers: userAnswers)
        }
    }
    
    func didTapAudioButton(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.getAudio(for: indexPath.row)
    }
}
