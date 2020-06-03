//
//  CourseListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class CourseListViewController: UIViewController {
    
    // View model
    private var viewModel: CourseListViewModel!
    
    // Delegates
    weak var delegate: CourseListViewControllerDelegate?
    
    // UI
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var headerView = UIView()
    private var tableViewHeaderHeight: CGFloat = {
        return UIScreen.main.bounds.height * 0.35
    }()
    let headerTitles = ["Courses"]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: CourseListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    fileprivate func setupUI() {
        
        view.backgroundColor = .white
        title = "Start Deutsch"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Help button
        let helpBarItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(didTapHelpButton(_:)))
        self.navigationItem.setLeftBarButton(helpBarItem, animated: true)
        
        // Reload button
        let reloadBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton))
        self.navigationItem.setRightBarButton(reloadBarItem, animated: true)
        
        // Header's image view
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalToSuperview().multipliedBy(0.65)
            make.center.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        imageView.image = UIImage(named: "background.png")
       
        // Table view
        tableView.contentInset = UIEdgeInsets(top: tableViewHeaderHeight , left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI configuration
        setupUI()
        
        // View model configuration
        viewModel.getCourses()
        
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

    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableViewHeaderHeight,
                                width: tableViewHeaderHeight*1.2,
                                height: tableViewHeaderHeight)
        if tableView.contentOffset.y < -tableViewHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    @objc private func didTapReloadButton(){
        if viewModel.courses.isEmpty{
            viewModel.getCourses()
        }
    }

}

extension CourseListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseTableViewCell
        let course = viewModel.courses[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.configure(course: course)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = viewModel.courses[indexPath.row]
        delegate?.didSelectCourse(course: course)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CourseListViewController: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            // hide internet connection failure
            ConnectionFailOverlay.shared.hideOverlayView()
            
            // show loading view
            LoadingOverlay.shared.showOverlay(view: view)
            
            // load data
            viewModel.getCourses()
        }
    }
}
