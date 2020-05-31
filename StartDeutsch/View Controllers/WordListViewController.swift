//
//  WordListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit
import Combine

class WordListViewController: UIViewController {
    
    // View model
    private var viewModel: WordListViewModel!
    
    init(viewModel: WordListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // UI
    private let assignmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    fileprivate func setupUI() {
        title = "Fragen formulieren"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //  Reload button
        let reloadBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton))
        self.navigationItem.setRightBarButton(reloadBarItem, animated: true)
        
        // Assignment label
        view.addSubview(assignmentLabel)
        assignmentLabel.text = "Practice asking questions using given word cards on different topics."
        assignmentLabel.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        })
        
        // Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(assignmentLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI configuration
        setupUI()
        
        // View model configuration
        viewModel.getWords()
        
        // View model state subscription
        viewModel.$state.sink(receiveValue: { [unowned self] state in
            switch state{
            case .loading:
                LoadingOverlay.shared.showOverlay(view: self.view)
            case .finish:
                self.collectionView.reloadData()
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
        viewModel.reloadWords()
    }

}
  
extension WordListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.randomWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WordCollectionViewCell
        let word = viewModel.randomWords[indexPath.row]
        cell.themeLabel.text = "Theme: " + word.theme
        cell.wordLabel.text = word.value
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-20, height: view.frame.height/5)
    }
}

extension WordListViewController: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            // hide internet connection failure
            ConnectionFailOverlay.shared.hideOverlayView()
            
            // show loading view
            LoadingOverlay.shared.showOverlay(view: view)
            
            // load data
            viewModel.getWords()
        }
    }
}



