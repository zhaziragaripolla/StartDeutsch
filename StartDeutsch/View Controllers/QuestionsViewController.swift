//
//  QuestionsViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    var viewModel: QuestionsViewModel!
    
    var selectedAnswers: [Int] = [0]
    
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

extension QuestionsViewController: QuestionsViewModelDelegate{
    func reloadData() {
        tableView.reloadData()
    }
}

extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableViewCell
        let question = viewModel.questions[indexPath.row]
        cell.url = viewModel.documentsUrl.appendingPathComponent("name.mp3")
        cell.questionLabel.text = question.question
        cell.delegate = self
        return cell
    }
    
    
}

extension QuestionsViewController: QuestionTableViewCellDelegate {
    func indexOfSelectedButton(index: Int, cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        selectedAnswers[indexPath.row] = index
        viewModel.checkUserAnswers(answerIndices: selectedAnswers)
    }
    
}
