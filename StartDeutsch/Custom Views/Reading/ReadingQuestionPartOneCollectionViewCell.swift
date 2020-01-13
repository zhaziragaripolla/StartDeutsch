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

class ReadingQuestionCollectionViewCell: UICollectionViewCell, CellConfigurable {
    func configure(with viewModel: QuestionCellViewModel) {
//        orderNumberLabel.text = "\(viewModel.orderNumber)/15"
    }
    var buttons: [UIButton] = []
    weak var delegate: AnswerToReadingQuestionSelectable?
    
    let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let answerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        changeButtonState(for: sender.tag)
        delegate?.didSelectSingleAnswer(cell: self, answer: sender.tag)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setRandomGradient()
        addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        })

//        addSubview(answerStackView)
//        answerStackView.snp.makeConstraints({ make in
//            make.top.equalTo(orderNumberLabel.snp.bottom).offset(10)
//            make.width.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.5)
//        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        answerStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        buttons.removeAll()
        resetView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetView(){
        buttons.forEach({$0.backgroundColor = .white})
    }
       
    func changeButtonState(for index: Int){
        resetView()
        buttons[index].backgroundColor = .orange
    }
    
}

class ReadingQuestionPartOneCollectionViewCell: ReadingQuestionCollectionViewCell {
    
    var answers: [Bool?] = []
    
    // Used for assigning a tag for generated buttons.
    var indexCounter = 0
    
    // There is only 2 type of buttons that user can tap to choose an answer: True or False. We have multiple questions with set of true/false buttons for each. This variable is required for calculating the index of question when user taps a button.
    var n = 2
    
    private var questionLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
   
//    func addButtonToStackView(state: Bool){
//        let button = UIButton.makeForBinaryQuestion(state)
//        button.tag = indexCounter
//        indexCounter += 1
//        button.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
//        buttons.append(button)
//        buttonStackView.addArrangedSubview(button)
//        answerStackView.addArrangedSubview(buttonStackView)
//    }
    
    private var buttonStackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        let falseButton = UIButton.makeForBinaryQuestion(false)
        let trueButton = UIButton.makeForBinaryQuestion(true)
        falseButton.tag = indexCounter
        indexCounter += 1
        trueButton.tag = indexCounter
        indexCounter += 1
        buttons.append(falseButton)
        buttons.append(trueButton)
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(falseButton)
        stackView.addArrangedSubview(trueButton)
        return stackView
    }
    
    @objc override func didTapAnswerButton(_ sender: UIButton){
        print(sender.tag)
        changeButtonState(for: sender.tag)
        let indexOfQuestion = sender.tag/n
        let state = sender.defineAnswerState()
        answers[indexOfQuestion] = state
        print(answers)
        delegate?.didSelectMultipleAnswer(cell: self, answers: answers)
    }
    
    override func changeButtonState(for index: Int) {
        // resetting buttons for same question
        if (index.isMultiple(of: 2)) {
            buttons[index+1].backgroundColor = .white
        }
        else {
            buttons[index-1].backgroundColor = .white
        }
        buttons[index].backgroundColor = .orange
    }
    
    public func setUserAnswer(_ answers: [Bool?]) {
        for index in 0..<answers.count{
            if let answer = answers[index] {
                let buttonTag = 2 * index + answer.toInt
                changeButtonState(for: buttonTag)
            }
        }
    }

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
        answerStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
  
        addSubview(questionImageView)
        questionImageView.snp.makeConstraints({ make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.4)
        })
     
        addSubview(answerStackView)
        answerStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(20)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        guard let model = viewModel as? ReadingPartOneViewModel else {return}
        for text in model.texts{
            let label = questionLabel
            label.text = text
            answerStackView.addArrangedSubview(label)
            answerStackView.addArrangedSubview(buttonStackView)
            answers.append(nil)
        }
        questionImageView.load(url: model.imageUrl)
    }
}

