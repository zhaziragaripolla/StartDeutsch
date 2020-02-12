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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
     let assignmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 16
        label.font = .italicSystemFont(ofSize: calculatedFontSize)
        label.textAlignment = .center
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.text = "Read the text below and fill out a form with missing pieces of information."
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 16
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let blankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let revealButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderColor = .none
        button.setTitle("Reveal answer", for: .normal)
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 16
        button.titleLabel?.font = .boldSystemFont(ofSize: calculatedFontSize)
        return button
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    init(viewModel: BlankViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        textLabel.text = viewModel.text
        blankImageView.load(from: viewModel.imagePath)
        var index = 1
        var text = ""
        for answer in viewModel.answers {
            text.append("\(index). \(answer)\n")
            index += 1
        }
        answerLabel.text = text
        revealButton.addTarget(self, action: #selector(didTapRevealButton), for: .touchUpInside)
    }
    
    @objc func didTapRevealButton(){
        revealButton.isEnabled = false
        answerLabel.isHidden = false
    }
    
    private func setupView(){
        view.setRandomGradient()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        })
        
        stackView.addSubview(assignmentLabel)
        assignmentLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        })
        
        stackView.addSubview(textLabel)
        textLabel.snp.makeConstraints({ make in
            make.top.equalTo(assignmentLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })
        
        stackView.addSubview(blankImageView)
        blankImageView.snp.makeConstraints({ make in
            make.top.equalTo(textLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
            make.centerX.equalToSuperview()
        })

        stackView.addSubview(revealButton)
        revealButton.snp.makeConstraints({ make in
            make.top.equalTo(blankImageView.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        })
        
        stackView.addSubview(answerLabel)
        answerLabel.snp.makeConstraints({ make in
            make.top.equalTo(revealButton.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        })
        
        
    }
    
}
