//
//  TestListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class TestListViewController: UIViewController {
    
    // View model
    private var viewModel: TestListViewModel!
    
    // Delegate
    weak var delegate: TestListViewControllerDelegate?
    
    // Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // UI
    private let tableView = UITableView()
    
    init(viewModel: TestListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        
        title = viewModel.course.title
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Reload button
        let reloadBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton))
        self.navigationItem.setRightBarButton(reloadBarItem, animated: true)
        
        // Table View
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI configuration
        setupUI()
        
        // View model configuration
        viewModel.getTests()
        
        // View model state subscription
        viewModel.$state.sink(receiveValue: { [unowned self] state in
            switch state{
            case .loading:
                LoadingOverlay.shared.showOverlay(view: self.view)
            case .finish:
                self.tableView.reloadData()
                LoadingOverlay.shared.hideOverlayView()
            case .error(let error):
                guard let urlError = error as? URLError, urlError.code == URLError.notConnectedToInternet else {
                        ConnectionFailOverlay.shared.showOverlay(view: self.view, message: Constants.FailureMessage.other)
                        return
                }
                ConnectionFailOverlay.shared.showOverlay(view: self.view, message: Constants.FailureMessage.noInternetConnection)
            default: break
            }
        }).store(in: &cancellables)
    }
    
    @objc private func didTapReloadButton(){
        if viewModel.tests.isEmpty{
            viewModel.getTests()
        }
    }
    
}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.titleLabel.text = "Test \(indexPath.row+1)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = viewModel.tests[indexPath.row]
        delegate?.didSelectTest(test: test)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension TestListViewController: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            // hide internet connection failure
            ConnectionFailOverlay.shared.hideOverlayView()
            
            // show loading view
            LoadingOverlay.shared.showOverlay(view: view)
            
            // load data
            viewModel.getTests()
        }
    }
}
