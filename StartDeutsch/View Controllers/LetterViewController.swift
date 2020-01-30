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
        label.font = .boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 18
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let assignmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 16
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.font = .italicSystemFont(ofSize: calculatedFontSize)
        label.textAlignment = .center
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Schreiben Sie zu jedem Punkt ein bis zwei Sätze (circa 30 Wörter)."
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let answerImageView: UIImageView = {
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
        let calculatedFontSize = screenWidth / 375 * 12
        button.titleLabel?.font = .boldSystemFont(ofSize: calculatedFontSize)
        return button
    }()
    
    init(viewModel: LetterViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let constraintConstant: Int = 5
    
    @objc func didTapRevealButton(_ sender: UIButton) {
        revealButton.isEnabled = false
        answerImageView.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setRandomGradient()
        setupView()
        titleLabel.text = viewModel.title
        taskLabel.text = viewModel.task
        for point in viewModel.points {
            taskLabel.text! += "\n- \(point)"
        }
        answerImageView.isHidden = true
        answerImageView.load(from: viewModel.answerImagePath)
    }
    
    private func setupView(){
//        view.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints({ make in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.8)
//            make.height.equalToSuperview().multipliedBy(0.1)
//            make.centerX.equalToSuperview()
//        })
//
        view.addSubview(taskLabel)
        taskLabel.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })

        view.addSubview(assignmentLabel)
        assignmentLabel.snp.makeConstraints({ make in
            make.top.equalTo(taskLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })
        
        revealButton.addTarget(self, action: #selector(didTapRevealButton(_:)), for: .touchUpInside)
        view.addSubview(revealButton)
        revealButton.snp.makeConstraints({ make in
            make.top.equalTo(assignmentLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(answerImageView)
        answerImageView.snp.makeConstraints({ make in
            make.top.equalTo(revealButton.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }

}
