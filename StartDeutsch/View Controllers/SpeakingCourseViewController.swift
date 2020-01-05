//
//  SpeakingCourseViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

protocol SpeakingCourseViewControllerDelegate: class {
    func didSelectSpeakingPartOne()
    func didSelectSpeakingPartTwo()
    func didSelectSpeakingPartThree()
}

class SpeakingCourseViewController: UIViewController {

    private let tableView = UITableView()
    private let courseTitles = ["Teil 1", "Teil 2", "Teil 3"]
    weak var delegate: SpeakingCourseViewControllerDelegate?
    
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
        title = "Sprechen"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        tableView.reloadData()
    }

}

extension SpeakingCourseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = courseTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.didSelectSpeakingPartOne()
        case 1:
            delegate?.didSelectSpeakingPartTwo()
        case 2:
            delegate?.didSelectSpeakingPartThree()
        default:
            fatalError("Unsupported part of writing is selected")
        }
    }

}



