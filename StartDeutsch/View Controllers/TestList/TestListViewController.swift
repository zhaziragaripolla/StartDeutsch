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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tests"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.trailing.leading.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = viewModel.tests[indexPath.row]
        delegate?.didSelectTest(test: test)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TestListViewController: TestsViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
}
