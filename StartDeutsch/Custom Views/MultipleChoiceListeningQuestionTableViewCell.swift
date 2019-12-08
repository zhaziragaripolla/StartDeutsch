//
//  MultipleChoiceListeningQuestionTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class MultipleChoiceListeningQuestionTableViewCell: UITableViewCell {
    
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
    
    @objc func didTapAudioButton(){
        LoadingOverlay.shared.showOverlay(view: audioButton)
        delegate?.didTapAudioButton(self)
    }

    var firstChoiceButton = UIButton()
    var secondChoiceButton = UIButton()
    var thirdChoiceButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstChoiceButton = UIButton.makeForAnswerChoice()
        secondChoiceButton = UIButton.makeForAnswerChoice()
        thirdChoiceButton = UIButton.makeForAnswerChoice()
        
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
            make.height.equalTo(contentView).multipliedBy(0.2)
        })
        
        contentView.addSubview(audioButton)
        audioButton.addTarget(self, action: #selector(didTapAudioButton), for: .touchUpInside)
        audioButton.snp.makeConstraints({ make in
            make.leading.equalTo(questionLabel.snp.trailing).offset(10)
            make.top.trailing.equalTo(contentView)
            make.width.height.equalTo(50)
//            make.centerX.equalTo(questionLabel.snp.centerX)
        })
        
        
        contentView.addSubview(firstChoiceButton)
        firstChoiceButton.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.trailing.equalToSuperview()
            make.leading.equalTo(contentView).offset(5)
//            make.bottom.lessThanOrEqualToSuperview()
        })
        
        contentView.addSubview(secondChoiceButton)
        secondChoiceButton.snp.makeConstraints({ make in
            make.top.equalTo(firstChoiceButton.snp.bottom).offset(5)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.trailing.equalToSuperview()
            make.leading.equalTo(contentView).offset(5)
//            make.bottom.lessThanOrEqualToSuperview()
        })
        
        contentView.addSubview(thirdChoiceButton)
        thirdChoiceButton.snp.makeConstraints({ make in
            make.top.equalTo(secondChoiceButton.snp.bottom).offset(5)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.trailing.equalToSuperview()
            make.leading.equalTo(contentView).offset(5)
            make.bottom.lessThanOrEqualToSuperview()
        })
        
    }
    
    
    
    func configure(with viewModel: ListeningQuestionViewModel) {
        questionLabel.text = viewModel.question
        LoadingOverlay.shared.hideOverlayView()
        firstChoiceButton.setTitle(viewModel.answerChoices.first, for: .normal)
        secondChoiceButton.setTitle(viewModel.answerChoices[1], for: .normal)
        thirdChoiceButton.setTitle(viewModel.answerChoices[2], for: .normal)
    }

}


fileprivate extension UIButton {
    static func makeForAnswerChoice() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .left
        return button
    }
}
