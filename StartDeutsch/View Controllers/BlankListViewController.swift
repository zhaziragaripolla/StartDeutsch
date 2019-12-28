//
//  BlankListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/25/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

protocol BlankListViewControllerDelegate: class {
    func didSelectBlank(detailViewModel: BlankViewModel)
}

class BlankListViewController: UIViewController {
    
    private var viewModel: BlankListViewModel!
    let tableView = UITableView()
    weak var delegate: BlankListViewControllerDelegate?
    
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

    init(viewModel: BlankListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Teil 1"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        viewModel.delegate = self
        viewModel.getBlanks()
    }

}

extension BlankListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.blanks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let blank = viewModel.blanks[indexPath.row]
        cell.textLabel?.text = blank.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blankViewModel = viewModel.getDetailViewModel(for: indexPath.row)
        print(delegate)
        delegate?.didSelectBlank(detailViewModel: blankViewModel)
    }
    
}

extension BlankListViewController: BlankListViewModelDelegate{
    func didDownloadBlanks() {
        tableView.reloadData()
    }
}
