//
//  TestListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

class TestListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var viewModel: TestListViewModel!
    weak var delegate: TestListViewControllerDelegate?
    
    init(viewModel: TestListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.course.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        view.backgroundColor = .white
        viewModel.delegate = self
        viewModel.getTests()
    }
    

}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test \(indexPath.row+1)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = viewModel.tests[indexPath.row]
        delegate?.didSelectTest(test: test)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TestListViewController: ViewModelDelegate {

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
