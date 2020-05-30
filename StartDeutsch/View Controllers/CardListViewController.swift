//
//  CardListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SDWebImage

class CardListViewController: UIViewController {
    
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
    
    private var viewModel: CardListViewModel!
    
    init(viewModel: CardListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getCards()
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
                guard error != nil else {
                    // Successful in loading image
                    cell.activityIndicator.stopAnimating()
                    cell.cardImageView.image = image
                    return
                }
                // Failed to load image
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


extension CardListViewController: ViewModelDelegate, ErrorDelegate {
    func didDownloadData() {
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
}




