//
//  ReadingQuestionPartOneCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

protocol AnswerToReadingQuestionSelectable: class {
    func didSelectMultipleAnswer(cell: UICollectionViewCell, answers: [Bool?])
    func didSelectSingleAnswer(cell: UICollectionViewCell, answer: Int)
}

class ReadingQuestionPartOneCollectionViewCell: UICollectionViewCell {
    
    var answers: [Bool?] = []
    var buttons: [UIButton] = []
    
    // Used for assigning a tag for generated buttons.
    var indexCounter = 0
    
    // There is only 2 type of buttons that user can tap to choose an answer: True or False. We have multiple questions with set of true/false buttons for each. This variable is required for calculating the index of question when user taps a button.
    var n = 2
    
    weak var delegate: AnswerToReadingQuestionSelectable?
    
    private var questionLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        return label
    }
   
    private var answerButtonsStackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        let trueButton = UIButton.makeForBinaryQuestion(true)
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        trueButton.tag = indexCounter
        indexCounter += 1
        stackView.addArrangedSubview(trueButton)
        trueButton.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(40)
        })
        let falseButton = UIButton.makeForBinaryQuestion(false)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.tag = indexCounter
        indexCounter += 1
        stackView.addArrangedSubview(falseButton)
        falseButton.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(40)
        })
        return stackView
    }
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        print(sender.tag)
        let indexOfQuestion = sender.tag/n
        let state = sender.defineAnswerState()
        answers[indexOfQuestion] = state
        delegate?.didSelectMultipleAnswer(cell: self, answers: answers)
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexCounter = 0
        answers.removeAll()
        stackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRandomGradient()
        
        addSubview(questionImageView)
        questionImageView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.4)
        })
     
        addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(20)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReadingQuestionPartOneCollectionViewCell: CellConfigurable{
    func configure(with viewModel: QuestionCellViewModel) {
        guard let model = viewModel as? ReadingPartOneViewModel else {return}
        for text in model.texts{
            let label = questionLabel
            label.text = text
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(answerButtonsStackView)
            answers.append(nil)
        }
        questionImageView.load(url: model.imageUrl)
    }
}
