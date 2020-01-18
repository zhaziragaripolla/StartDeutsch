//
//  ListeningQuestionCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/11/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

enum State {
    case mistake
    case correct
    case chosen
}

struct Answer{
    static func setColor(_ state: State)-> UIColor {
        switch state {
        case .chosen: return .orange
        case .correct: return UIColor.init(hexString: "7fcd91")
        case .mistake: return UIColor.init(hexString: "eb4d55")
        }
    }
}

protocol ListeningQuestionDelegate: class {
    func didTapAudioButton(_ cell: UICollectionViewCell)
    func didSelectAnswer(index: Int, cell: UICollectionViewCell)
}

class ListeningQuestionCollectionViewCell: UICollectionViewCell, CellConfigurable{
  
    weak var delegate: ListeningQuestionDelegate?
    var buttons: [UIButton] = []
    private var isPlaying: Bool = false
    
    let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play.fill"), for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    var answerButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        resetView()
        changeButtonState(for: sender.tag, state: .chosen)
        delegate?.didSelectAnswer(index: sender.tag, cell: self)
    }
    
    @objc private func didTapAudioButton(_ sender: UIButton){
        isPlaying = !isPlaying
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        audioButton.setImage(UIImage(systemName: imageName), for: .normal)
        delegate?.didTapAudioButton(self)
    }
    
    public func resetView(){
        buttons.forEach({
            $0.backgroundColor = .white
            $0.setTitleColor(.systemBlue, for: .normal)
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        answerButtonStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        buttons.removeAll()
        resetView()
    }
    
    func changeButtonState(for index: Int, state: State){
        buttons[index].backgroundColor = Answer.setColor(state)
        buttons[index].setTitleColor(.white, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRandomGradient()
        addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        })

        addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
        })

        addSubview(answerButtonStackView)
        answerButtonStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        })

        addSubview(audioButton)
        audioButton.addTarget(self, action: #selector(didTapAudioButton(_:)), for: .touchUpInside)
        audioButton.snp.makeConstraints({ make in
            make.height.width.equalTo(50)
            make.top.equalTo(answerButtonStackView.snp.bottom).offset(50)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: QuestionCellViewModel) {
        if let viewModel = viewModel as? ListeningQuestionViewModel {
            questionLabel.text = viewModel.question
            orderNumberLabel.text = "\(viewModel.orderNumber)/15"
        }
    }
    
}

class ListeningQuestionBinaryChoiceCollectionViewCell: ListeningQuestionCollectionViewCell {
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        let falseButton = UIButton.makeForBinaryQuestion(false)
        let trueButton = UIButton.makeForBinaryQuestion(true)
        
        buttons.append(falseButton)
        buttons.append(trueButton)
        
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        answerButtonStackView.addArrangedSubview(falseButton)
        answerButtonStackView.addArrangedSubview(trueButton)
    }
}

class ListeningQuestionMultipleChoiceCollectionViewCell: ListeningQuestionCollectionViewCell {
    
    @objc override func didTapAnswerButton(_ sender: UIButton){
        resetView()
        for index in 0..<buttons.count {
            if buttons[index] == sender {
                changeButtonState(for: index, state: .chosen)
                delegate?.didSelectAnswer(index: index, cell: self)
            }
        }
    }
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        guard let viewModel = viewModel as? ListeningQuestionMultipleChoiceViewModel else { return }
        viewModel.answerChoices.forEach({
            let button = UIButton.makeForAnswerChoice(title: $0)
            button.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
            buttons.append(button)
            answerButtonStackView.addArrangedSubview(button)
        })
    }

}
