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
    
    var firstChoiceButton = UIButton()
    var secondChoiceButton = UIButton()
    var thirdChoiceButton = UIButton()
    
    @objc func didTapAudioButton(){
        LoadingOverlay.shared.showOverlay(view: audioButton)
        delegate?.didTapAudioButton(self)
    }
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        changeButtonState(sender.tag)
        delegate?.didSelectAnswer(sender.tag, self)
    }
    
    private func changeButtonState(_ index: Int){
        let buttons = [firstChoiceButton, secondChoiceButton, thirdChoiceButton]
        
        if buttons[index].backgroundColor == .none {
            buttons.forEach({ $0.backgroundColor = .none})
            buttons[index].backgroundColor = .green
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstChoiceButton = UIButton.makeForAnswerChoice(tag: 0)
        secondChoiceButton = UIButton.makeForAnswerChoice(tag: 1)
        thirdChoiceButton = UIButton.makeForAnswerChoice(tag: 2)
        
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
        firstChoiceButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        firstChoiceButton.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.trailing.equalToSuperview()
            make.leading.equalTo(contentView).offset(5)
//            make.bottom.lessThanOrEqualToSuperview()
        })
        
        contentView.addSubview(secondChoiceButton)
        secondChoiceButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        secondChoiceButton.snp.makeConstraints({ make in
            make.top.equalTo(firstChoiceButton.snp.bottom).offset(5)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.trailing.equalToSuperview()
            make.leading.equalTo(contentView).offset(5)
//            make.bottom.lessThanOrEqualToSuperview()
        })
        
        contentView.addSubview(thirdChoiceButton)
        thirdChoiceButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
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
    static func makeForAnswerChoice(tag: Int?) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .left
        if let tag = tag {
            button.tag = tag
        }
        return button
    }
}
