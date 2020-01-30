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
    private let courseTitles = ["W-question cards", "\"Bitte\" sentences"]
    private let courseSubtitles = ["Let's train asking question on 10+ common topics", "Practice making polite requests with 100+ cards"]
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = courseTitles[indexPath.row]
        cell.detailTextLabel?.text = courseSubtitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.didSelectSpeakingPartTwo()
        case 1:
            delegate?.didSelectSpeakingPartThree()
        default:
            print("Unsupported part of writing is selected")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}



