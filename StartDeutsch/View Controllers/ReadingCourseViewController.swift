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

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
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
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getQuestions()
    }
}

extension ReadingCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellViewModelList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier(for: cellViewModel), for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.configure(with: cellViewModel)
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
        return CGSize(width: view.frame.width, height: view.frame.height)
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
