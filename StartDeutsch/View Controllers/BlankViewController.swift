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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
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
        button.setTitle("Antworten anzeigen", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        titleLabel.text = viewModel.title
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
        
//        view.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints({ make in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.1)
//            make.centerX.equalToSuperview()
//        })
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(blankImageView)
        blankImageView.snp.makeConstraints({ make in
            make.top.equalTo(textLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        })

        view.addSubview(revealButton)
        revealButton.snp.makeConstraints({ make in
            make.top.equalTo(blankImageView.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints({ make in
            make.top.equalTo(revealButton.snp.bottom).offset(5)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        })
        
        
    }
    
}
