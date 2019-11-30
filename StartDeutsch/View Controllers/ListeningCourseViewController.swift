//
//  ListeningCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

class ListeningCourseViewController: UIViewController {
    
    var viewModel: ListeningViewModel!
    
    init(viewModel: ListeningViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userAnswers = [UserAnswer](repeating: UserAnswer(), count: 15)
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getQuestions()
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BinaryListeningQuestionTableViewCell.self, forCellReuseIdentifier: "binaryQuestion")
        tableView.register(MultipleChoiceListeningQuestionTableViewCell.self, forCellReuseIdentifier: "multipleQuestion")
        
    }
}

extension ListeningCourseViewController: ListeningViewModelDelegate, ErrorDelegate {
    func questionsDownloaded() {
        viewModel.getAudios()
        LoadingOverlay.shared.showOverlay(view: view)
        tableView.isHidden = true
    }
    
    func showError(message: String) {
        print(message)
    }
    
    func reloadData() {
        LoadingOverlay.shared.hideOverlayView()
        tableView.isHidden = false
        tableView.reloadData()
    }
}

extension ListeningCourseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionViewModel = viewModel.viewModel(for: indexPath.row)
        
        if questionViewModel.isMultipleChoice {
            let cell = tableView.dequeueReusableCell(withIdentifier: "multipleQuestion", for: indexPath) as! MultipleChoiceListeningQuestionTableViewCell
            cell.configure(with: questionViewModel)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "binaryQuestion", for: indexPath) as! BinaryListeningQuestionTableViewCell
            cell.configure(with: questionViewModel)
            return cell
        }
        
        // cell.delegate = self
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let questionViewModel = viewModel.viewModel(for: indexPath.row)
        return questionViewModel.isMultipleChoice ? 200 : 120
    }
}
//
//extension ListeningViewController: ListeningTableViewCellDelegate {
//    func indexOfSelectedButton(index: Int, cell: UITableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//
//        let userAnswer = UserAnswer(value: index, isAnswered: true)
//        userAnswers[indexPath.row] = userAnswer
//
//        // check only if all 15 questions are answered
//        print(userAnswers)
//        if !userAnswers.contains(where: { $0.isAnswered == false }) {
//            let result = viewModel.checkUserAnswers(userAnswers: userAnswers)
//            print(result)
//        }
//    }
//
//}
