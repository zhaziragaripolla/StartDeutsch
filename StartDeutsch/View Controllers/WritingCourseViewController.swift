//
//  WritingCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/25/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

protocol WritingCourseViewControllerDelegate: class {
    func didSelectWritingPartOne()
    func didSelectWritingPartTwo()
}

class WritingCourseViewController: UIViewController {

    let tableView = UITableView()
    let writingCourseTitles = ["Teil 1", "Teil 2"]
    weak var delegate: WritingCourseViewControllerDelegate?
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Schreiben"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        tableView.reloadData()
    }

}

extension WritingCourseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writingCourseTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = writingCourseTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.didSelectWritingPartOne()
        case 1:
            delegate?.didSelectWritingPartTwo()
        default:
            fatalError("Unsupported part of writing is selected")
        }
    }

}


