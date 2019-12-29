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
    
    private let answerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Antworten anzeigen", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return button
    }()
    
    private let answerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()

    init(viewModel: BlankViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isShowingAnswers = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
        blankImageView.load(url: viewModel.url)
        var index = 1
        for answer in viewModel.answers {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text =  "\(index). \(answer)"
            index += 1
            answerStackView.addArrangedSubview(label)
        }
        answerButton.addTarget(self, action: #selector(didTapRevealAnswerButton), for: .touchUpInside)
    }
    
    @objc func didTapRevealAnswerButton(){
        isShowingAnswers = !isShowingAnswers
        answerStackView.isHidden = !isShowingAnswers
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
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(blankImageView)
        blankImageView.snp.makeConstraints({ make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.35)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(answerButton)
        answerButton.snp.makeConstraints({ make in
            make.top.equalTo(blankImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        })
        
        view.addSubview(answerStackView)
        answerStackView.snp.makeConstraints({ make in
            make.top.equalTo(answerButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalTo(view.snp.bottom).inset(30)
        })
        
        
    }
    
}
