//
//  CourseListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

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
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Start Deutsch A1"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getCourses()
    }

}

extension CourseListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseTableViewCell
        let course = viewModel.courses[indexPath.row]
        cell.configure(course: course)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = viewModel.courses[indexPath.row]
        delegate?.didSelectCourse(course: course)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/5
    }
}

extension CourseListViewController: ViewModelDelegate, ErrorDelegate {
    func didStartLoading() {
        LoadingOverlay.shared.showOverlay(view: view)
    }
    
    func didCompleteLoading() {
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func networkOffline() {
        ConnectionFailOverlay.shared.showOverlay(view: view)
    }
    
    func networkOnline() {
        ConnectionFailOverlay.shared.hideOverlayView()
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func didDownloadData() {
        tableView.reloadData()
    }
    
}
