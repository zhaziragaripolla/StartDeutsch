//
//  ListeningQuestionBinaryChoiceTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

protocol ListeningCellDelegate: class {
    func didTapAudioButton(_ cell: UITableViewCell)
    func didSelectAnswer(_ index: Int, _ cell: UITableViewCell)
}

class ListeningQuestionBinaryChoiceTableViewCell: UITableViewCell {
    
    public weak var delegate: ListeningCellDelegate?
    var isPlaying: Bool = false
    private var buttons: [UIButton] = []
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play"), for: .normal)
        
        return button
    }()
    
    private let trueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("Richtig", for: .normal)
        button.tag = 1
        return button
    }()
    
    private let falseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("Falsch", for: .normal)
        button.tag = 0
        return button
    }()
    
    @objc private func didTapAudioButton(_ sender: UIButton){
        LoadingOverlay.shared.showOverlay(view: audioButton)
        delegate?.didTapAudioButton(self)
    }
    
    @objc private func didTapAnswerButton(_ sender: UIButton){
        changeButtonState(sender.tag)
        delegate?.didSelectAnswer(sender.tag, self)
    }
    
    private func resetView(){
        buttons.forEach({$0.backgroundColor = .none})
    }

    func startPlay(){
        
    }
    
    public func changeButtonState(_ index: Int){
        resetView()
        buttons[index].backgroundColor = .green
    }
    
    public func configure(with viewModel: ListeningQuestionViewModel) {
        questionLabel.text = viewModel.question
        LoadingOverlay.shared.hideOverlayView()
        print("calling")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buttons = [falseButton, trueButton]
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI(){
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
        
        contentView.addSubview(falseButton)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.leading.equalTo(contentView).offset(5)
            make.bottom.lessThanOrEqualToSuperview()
        })
        
        contentView.addSubview(trueButton)
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        trueButton.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.height.equalTo(contentView).multipliedBy(0.2)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.leading.greaterThanOrEqualTo(trueButton.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-5)
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
}
extension UIButton {
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
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
