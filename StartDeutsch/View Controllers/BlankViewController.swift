//
//  BlankViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/25/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

class BlankViewController: UIViewController {
    
    private var viewModel: BlankViewModel!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 34)
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let blankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(viewModel: BlankViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
        blankImageView.load(url: viewModel.url)
    }
    
    private func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        })
       
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        })
        
        view.addSubview(blankImageView)
        blankImageView.snp.makeConstraints({ make in
            make.top.equalTo(textLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview()
        })
    }
    
}
