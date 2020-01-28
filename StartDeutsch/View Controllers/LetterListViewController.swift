//
//  LetterListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/25/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

protocol LetterListViewControllerDelegate: class {
    func didSelectLetter(detailViewModel: LetterViewModel)
}

class LetterListViewController: UIViewController {
    
    private var viewModel: LetterListViewModel!
    private let tableView = UITableView()
    weak var delegate: LetterListViewControllerDelegate?
    
    init(viewModel: LetterListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        title = "Letters"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getLetters()
    }

}


extension LetterListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.letters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let letter = viewModel.letters[indexPath.row]
        cell.textLabel?.text = letter.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let letterViewModel = viewModel.getDetailViewModel(for: indexPath.row)
        delegate?.didSelectLetter(detailViewModel: letterViewModel)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension LetterListViewController: ViewModelDelegate, ErrorDelegate{
    func didDownloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
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
}

