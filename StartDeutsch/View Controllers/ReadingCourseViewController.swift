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
    private let tableView = UITableView()

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
    
    fileprivate func setupTableView() {
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
             collectionView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
            cell.delegate = self
            cell.configure(with: cellViewModel!)
        }
        return cell
    }
    
    private func cellIdentifier(for viewModel: QuestionCellViewModel)-> String {
        switch viewModel {
        case is ReadingPartOneViewModel:
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
        print("Downloaded questions!!")
        tableView.reloadData()
        collectionView.reloadData()
    }
    
}

extension ReadingCourseViewController: ReadingQuestionDelegate{
    // TODO: Refactor
    func didSelectMultipleAnswer(cell: UICollectionViewCell, answers: [Bool?]) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        userAnswers[indexPath.row] = answers
        if userAnswers.values.count == 12 {
            viewModel.checkUserAnswers(userAnswers: userAnswers)
        }
    }
    
    func didSelectSignleAnswer(cell: UICollectionViewCell, answer:
    Int) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        userAnswers[indexPath.row] = answer
        print(userAnswers)
        if userAnswers.values.count == 12 {
            viewModel.checkUserAnswers(userAnswers: userAnswers)
        }
    }
    
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
