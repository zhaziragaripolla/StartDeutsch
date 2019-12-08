//
//  ListeningQuestionTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

protocol ListeningCellDelegate: class {
    func didTapAudioButton(_ cell: UITableViewCell)
}

class BinaryListeningQuestionTableViewCell: UITableViewCell {
    
    weak var delegate: ListeningCellDelegate?
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play"), for: .normal)
        
        return button
    }()
    
    let trueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("Richtig", for: .normal)
//        button.tintColor = .white
//        button.backgroundColor = .green
//        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
       
        return button
    }()
    
    let falseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("Falsch", for: .normal)
//        button.tintColor = .white
//        button.backgroundColor = .red
        return button
    }()
    
    @objc func didTapAudioButton(_ sender: UIButton){
        LoadingOverlay.shared.showOverlay(view: audioButton)
        delegate?.didTapAudioButton(self)
    }
    
    func startPlay(){
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI(){
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.leading.equalTo(contentView).offset(10)
            make.top.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.8)
            make.height.equalTo(contentView).multipliedBy(0.3)
        })
   
        contentView.addSubview(audioButton)
        audioButton.addTarget(self, action: #selector(didTapAudioButton(_:)), for: .touchUpInside)
        audioButton.snp.makeConstraints({ make in
            make.leading.equalTo(questionLabel.snp.trailing).offset(10)
            make.top.trailing.equalTo(contentView)
            make.width.height.equalTo(50)
//            make.centerX.equalTo(questionLabel.snp.centerX)
        })
        
        contentView.addSubview(trueButton)
        trueButton.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.leading.equalTo(contentView).offset(5)
            make.bottom.lessThanOrEqualToSuperview()
        })
        
        contentView.addSubview(falseButton)
        falseButton.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.leading.greaterThanOrEqualTo(trueButton.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-5)
            make.bottom.lessThanOrEqualToSuperview()
        })
        
    }
    
  
    
    func configure(with viewModel: ListeningQuestionViewModel) {
        questionLabel.text = viewModel.question
        LoadingOverlay.shared.hideOverlayView()
    }
}

fileprivate extension UIButton {
    static func makeForAnswerChoice(title: String) -> UIButton {
        let button = UIButton()
//        print(title)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textColor = .blue
        return button
    }
    
    static func makeForBinaryQuestion(_ state: Bool) -> UIButton {
        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textColor = .blue
        if state {
            button.setTitle("Richtig", for: .normal)
        }
        else {
            button.setTitle("Falsch", for: .normal)
        }
        return button
    }
}
