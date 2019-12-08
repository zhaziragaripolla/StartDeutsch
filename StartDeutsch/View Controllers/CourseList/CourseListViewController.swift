//
//  CourseListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import SwiftCSV

class CourseListViewController: UIViewController {

    private let tableView = UITableView()
    weak var delegate: CourseListViewControllerDelegate?
    private var viewModel: CourseListViewModel!
    
    init(viewModel: CourseListViewModel) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Start Deutsch A1"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        
        viewModel.delegate = self
        viewModel.getCourses()
//
//        if let url = Bundle.main.url(forResource: "listening1-5", withExtension: "csv") {
//            if let csvFile: CSV = try? CSV(url: url) {
//
//                csvFile.enumeratedRows.forEach({
//                    let id = UUID()
//                    let orderNumber = Int($0[1])!
//                    if $0[0].toBool()!{
//                        // is Multiple choice
//
//                        let question = ListeningQuestion(id: id.description, testId: "vUscu1si4CBOX63vopgY", questionText: $0[2], orderNumber: orderNumber, answerChoices: [$0[3], $0[4], $0[5]], correctChoiceIndex: Int($0[6])!, isMultipleChoice: true, audioPath: "test1/\(orderNumber).mp3")
//                        viewModel.save(question: question)
//                    }
//                    else {
//                        // true/false questionText
//                        let question = ListeningQuestion(id: id.description, testId: "vUscu1si4CBOX63vopgY", questionText: $0[2], orderNumber: orderNumber, answerChoices: nil, correctChoiceIndex: Int($0[6])!, isMultipleChoice: false, audioPath: "test1/\(orderNumber).mp3")
//                        viewModel.save(question: question)
//                    }
//
//                })
//            }
//        }
//        else {
//            print("Error")
//        }
//
    }

}

extension CourseListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let course = viewModel.courses[indexPath.row]
        cell.textLabel?.text = course.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = viewModel.courses[indexPath.row]
        delegate?.didSelectCourse(course: course)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CourseListViewController: CoursesViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}


extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
