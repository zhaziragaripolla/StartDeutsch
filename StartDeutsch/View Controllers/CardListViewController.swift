//
//  CardListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit
import Combine
import SDWebImage

class CardListViewController: UIViewController {
    
    // View model
    private var viewModel: CardListViewModel!
    
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
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    fileprivate func setupUI() {
        title = "Bitten formulieren"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Reload button
        let reloadBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton))
        self.navigationItem.setRightBarButton(reloadBarItem, animated: true)
        
        // Assignment label
        view.addSubview(assignmentLabel)
        assignmentLabel.text = "Practice making polite requests using objects on the cards."
        assignmentLabel.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        })
        
        // Collection View
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(assignmentLabel.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    
    init(viewModel: CardListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI configuration
        setupUI()
        
        // View model configuration
        viewModel.getCards()
        
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
        viewModel.reloadImages()
    }

}

extension CardListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.randomCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCollectionViewCell
        cell.activityIndicator.startAnimating()
        if let url = URL(string: viewModel.randomCards[indexPath.row].imageUrl){
            cell.cardImageView.sd_setImage(with: url) { (image, error, cache, urls) in
                guard let urlError = error as? URLError, urlError.code == URLError.notConnectedToInternet else {
                    // Successful in loading image
                    cell.activityIndicator.stopAnimating()
                    cell.cardImageView.image = image
                    return
                }
                // Failure
                ConnectionFailOverlay.shared.showOverlay(view: self.view, message: Constants.FailureMessage.noInternetConnection)
                cell.cardImageView.image = UIImage(named: "placeholder")
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
 

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-20, height: view.frame.height/5)
    }
}


extension CardListViewController: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            // hide internet connection failure
            ConnectionFailOverlay.shared.hideOverlayView()
            
            // show loading view
            LoadingOverlay.shared.showOverlay(view: view)
            
            // load data
            viewModel.getCards()
        }
    }
}


