//
//  ListeningViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ListeningViewController: UIViewController {
    
    var viewModel: QuestionsViewModel!
    
    var userAnswers = [UserAnswer](repeating: UserAnswer(), count: 15)
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel = QuestionsViewModel()
        viewModel.delegate = self
        viewModel.getQuestions()
        viewModel.getAudios()
//        tableView.
    }
}

extension ListeningViewController: QuestionsViewModelDelegate {
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension ListeningViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = viewModel.questions[indexPath.row]
//        var cell: ListeningTableViewCellProtocol?
        if question.choices?.count == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMultiple", for: indexPath) as! QuestionTableViewCell
            cell.url = viewModel.documentsUrl.appendingPathComponent("name.mp3")
            cell.questionLabel.text = question.question
            cell.firstAnswerLabel.text = question.choices?[0]
            cell.secondAnswerLabel.text = question.choices?[1]
            cell.thirdAnswerLabel.text = question.choices?[2]
            cell.delegate = self
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellBinary", for: indexPath) as! BinaryQuestionTableViewCell
            cell.url = viewModel.documentsUrl.appendingPathComponent("name.mp3")
            cell.questionLabel.text = question.question
            cell.delegate = self
            return cell
        }
        
    }
    
    
}

extension ListeningViewController: ListeningTableViewCellDelegate {
    func indexOfSelectedButton(index: Int, cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        let userAnswer = UserAnswer(value: index, isAnswered: true)
        userAnswers[indexPath.row] = userAnswer
        
        // check only if all 15 questions are answered
        print(userAnswers)
        if !userAnswers.contains(where: { $0.isAnswered == false }) {
            let result = viewModel.checkUserAnswers(userAnswers: userAnswers)
            print(result)
        }
    }
    
}
