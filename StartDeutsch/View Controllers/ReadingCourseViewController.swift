//
//  ReadingCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

class ReadingCourseViewController: UIViewController {

    private var viewModel: ReadingCourseViewModel!
    private var userAnswers = [UserAnswer](repeating: UserAnswer(), count: 15)
    private let tableView = UITableView()
    
    init(viewModel: ReadingCourseViewModel) {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ReadingPartOneTableViewCell.self, forCellReuseIdentifier: "partOne")
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getQuestions()
    }
}

extension ReadingCourseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.questionsPartOne.count + viewModel.questionsPartTwo.count + viewModel.questionsPartThree.count
        return viewModel.questionsPartOne.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0...1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "partOne", for: indexPath) as! ReadingPartOneTableViewCell
            let questionPartOne = viewModel.questionsPartOne[indexPath.row]
            let url = viewModel.imageUrls[questionPartOne.imagePath]
            cell.configure(question: questionPartOne)
            cell.questionImageView.load(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/startdeutsch-34bdd.appspot.com/o/test1%2Freading%2F1.png?alt=media&token=e5abe96c-7587-4fa2-b5ca-157225d08399")!)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
        
    }
}

extension ReadingCourseViewController: ErrorDelegate, ReadingCourseViewModelDelegate{
 
    func showError(message: String) {
        print(message)
    }
    
    func didDownloadQuestions() {
        print("Downloaded questions!!")
        tableView.reloadData()
    }
    
}
