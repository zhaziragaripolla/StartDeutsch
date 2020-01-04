//
//  LetterViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/25/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class LetterViewController: UIViewController {
    
    private var viewModel: LetterViewModel!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 34)
        label.textAlignment = .center
        return label
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let answerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(viewModel: LetterViewModel) {
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
        taskLabel.text = viewModel.task
        for point in viewModel.points {
            taskLabel.text! += point
        }
        answerImageView.load(url: viewModel.answerImagePath)
    }
    
    private func setupView(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        })
        
        view.addSubview(taskLabel)
        taskLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        })
        
        view.addSubview(answerImageView)
        answerImageView.snp.makeConstraints({ make in
            make.top.equalTo(taskLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.35)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

}
