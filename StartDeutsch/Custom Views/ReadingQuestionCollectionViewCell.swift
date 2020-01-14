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

    fileprivate var buttons: [UIButton] = []
    weak var delegate: AnswerToReadingQuestionSelectable?
    
    fileprivate let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let answerStackView: UIStackView = {
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

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        answerStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        resetView()
        buttons.removeAll()
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
    
    func configure(with viewModel: QuestionCellViewModel) {
        guard let viewModel = viewModel as? ReadingQuestionViewModel else { return }
        orderNumberLabel.text = "\(viewModel.orderNumber)/12"
    }
    
}

class ReadingQuestionPartOneCollectionViewCell: ReadingQuestionCollectionViewCell {
    
    private var answers: [Bool?] = []
    
    // There is only 2 type of buttons that user can tap to choose an answer: True or False. We have multiple questions with set of true/false buttons for each. This variable is required for calculating the index of question when user taps a button.
    private var n = 2
    
    private var buttonStackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        let falseButton = UIButton.makeForBinaryQuestion(false)
        let trueButton = UIButton.makeForBinaryQuestion(true)
        buttons.append(falseButton)
        buttons.append(trueButton)
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(falseButton)
        stackView.addArrangedSubview(trueButton)
        return stackView
    }
    
    @objc override func didTapAnswerButton(_ sender: UIButton){
        for index in 0..<buttons.count {
            if buttons[index] == sender {
                changeButtonState(for: index)
                let indexOfQuestion = index/n
                answers[indexOfQuestion] = sender.defineAnswerState()
                delegate?.didSelectMultipleAnswer(cell: self, answers: answers)
            }
        }
    }
    
    // When some button(answer) is tapped, it is needed to reset other button background colors. But only for buttons that relate to the same question. All questions has n buttons that related to them. All buttons are saved into "buttons" array. So, first n buttons are related to 1st question, second n buttons relate to 2nd question and so on. Knowing index of selected button, we can calculate other buttons that need to be resetted. This function works only for n = 2.
    override func changeButtonState(for index: Int) {
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
                let indexOfSelectedButton = 2 * index + answer.toInt
                changeButtonState(for: indexOfSelectedButton)
            }
        }
    }

    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        guard let model = viewModel as? ReadingQuestionPartOneViewModel else {return}
        for text in model.texts{
            let label = UILabel.make()
            label.text = text
            answerStackView.addArrangedSubview(label)
            answerStackView.addArrangedSubview(buttonStackView)
            answers.append(nil)
        }
        questionImageView.load(url: model.imageUrl)
    }
}

class ReadingQuestionPartTwoCollectionViewCell: ReadingQuestionCollectionViewCell {
    
    private var cardViews: [CardView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })

        contentView.addSubview(answerStackView)
        answerStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardViews.removeAll()
    }
    
    override func changeButtonState(for index: Int) {
        resetView()
        cardViews[index].isSelected = true
    }
    
    private func resetView(){
        cardViews.forEach({
            $0.isSelected = false
        })
    }
    
    @objc func didTapCardView(_ sender: UITapGestureRecognizer){
        if let cardView = sender.view as? CardView {
            // Change UI to manage the selection state of the card view.
            resetView()
            cardView.isSelected = !cardView.isSelected
            
            // Delegate to View Controller the index of selected model.
            for index in 0..<cardViews.count{
                if cardViews[index] == cardView{
                    delegate?.didSelectSingleAnswer(cell: self, answer: index)
                }
            }
        }
    }
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        guard let model = viewModel as? ReadingPartTwoViewModel else {return}
        questionLabel.text = model.text
        for url in model.imageUrls{
            let cardView = CardView()
            answerStackView.addArrangedSubview(cardView)
            cardView.cardImageView.load(url: url)
            cardViews.append(cardView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCardView(_:)))
            cardView.addGestureRecognizer(tapGesture)
        }
    }
}

class ReadingQuestionPartThreeCollectionViewCell: ReadingQuestionCollectionViewCell {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .italicSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let trueButton = UIButton.makeForBinaryQuestion(true)
    private let falseButton = UIButton.makeForBinaryQuestion(false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints({ make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        })
        
        addSubview(questionImageView)
        questionImageView.snp.makeConstraints({ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        })
        
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
        })
        
        answerStackView.axis = .horizontal
        addSubview(answerStackView)
        answerStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        guard let model = viewModel as? ReadingPartThreeViewModel else {return}
        descriptionLabel.text = model.description
        questionLabel.text = model.text
        questionImageView.load(url: model.imageUrl)
        answerStackView.addArrangedSubview(falseButton)
        answerStackView.addArrangedSubview(trueButton)
        buttons.append(falseButton)
        buttons.append(trueButton)
    }
}


