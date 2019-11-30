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

//    @IBOutlet weak var tableView: UITableView!
    
    let tableView = UITableView()
    
    weak var delegate: CourseListViewControllerDelegate?
    
    let courses: [String] = ["Hören", "Lesen", "Schreiben", "Sprechen"]
    
    var viewModel: CoursesViewModel!
    
    init(viewModel: CoursesViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Start Deutsch A1"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        
//        if let url = Bundle.main.url(forResource: "listening1-5", withExtension: "csv") {
//            if let csvFile: CSV = try? CSV(url: url) {
//
//                csvFile.enumeratedRows.forEach({
//                    let id = UUID()
//                    let orderNumber = Int($0[1])!
//                    if $0[0].toBool()!{
//                        // is Multiple choice
//
//                        let question = ListeningQuestion(id: id.description, testId: "BD1C19A0-26AC-46B8-B38A-937422299D8E", questionText: $0[2], orderNumber: orderNumber, answerChoices: [$0[3], $0[4], $0[5]], correctChoiceIndex: Int($0[6])!, isMultipleChoice: true, audioPath: "test1/\(orderNumber).mp3")
//                        viewModel.save(question: question)
//                    }
//                    else {
//                        // true/false questionText
//                        let question = ListeningQuestion(id: id.description, testId: "BD1C19A0-26AC-46B8-B38A-937422299D8E", questionText: $0[2], orderNumber: orderNumber, answerChoices: nil, correctChoiceIndex: Int($0[6])!, isMultipleChoice: false, audioPath: "test1/\(orderNumber).mp3")
//                        viewModel.save(question: question)
//                    }
//
//                })
//            }
//        }
//        else {
//            print("Error")
//        }
        
    }

}

extension CourseListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCourse(courseId: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
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
