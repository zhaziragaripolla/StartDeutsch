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
    let writingCourseTitles = ["Blanks", "Letters"]
    private let courseSubtitles = ["Practice filling out forms", "Practice writing formal/informal letters"]
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = writingCourseTitles[indexPath.row]
        cell.detailTextLabel?.text = courseSubtitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
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
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


