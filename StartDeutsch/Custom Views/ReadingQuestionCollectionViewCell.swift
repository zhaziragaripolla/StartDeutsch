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

    var buttons: [UIButton] = []
    weak var delegate: AnswerToReadingQuestionSelectable?
    
    
    fileprivate let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 16
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 16
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.numberOfLines = 5
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    fileprivate let answerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        resetView()
        changeButtonState(for: sender.tag, state: .chosen)
        delegate?.didSelectSingleAnswer(cell: self, answer: sender.tag)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setRandomGradient()
        addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(5)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
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
        super.init(coder: coder)
    }
    
    func resetView(){
        buttons.forEach({$0.reset()})
    }
       
    func changeButtonState(for index: Int, state: AnswerState){
        buttons[index].setState(state)
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
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc override func didTapAnswerButton(_ sender: UIButton){
        for index in 0..<buttons.count {
            if buttons[index] == sender {
                resetView(index)
                changeButtonState(for: index, state: .chosen)
                let indexOfQuestion = index/n
                answers[indexOfQuestion] = sender.defineAnswerState()
                delegate?.didSelectMultipleAnswer(cell: self, answers: answers)
            }
        }
    }
    
    // When some button(answer) is tapped, it is needed to reset other button background colors. But only for buttons that relate to the same question. All questions has n buttons that related to them. All buttons are saved into "buttons" array. So, first n buttons are related to 1st question, second n buttons relate to 2nd question and so on. Knowing index of selected button, we can calculate other buttons that need to be resetted. This function works only for n = 2.
    override func changeButtonState(for index: Int, state: AnswerState) {
        buttons[index].setState(state)
    }
    
    func resetView(_ index: Int) {
        index.isMultiple(of: 2) ? buttons[index+1].reset() : buttons[index-1].reset()
    }
    
    public func setUserAnswer(_ answers: [Bool?], state: AnswerState) {
        for index in 0..<answers.count{
            if let answer = answers[index] {
                let indexOfSelectedButton = 2 * index + answer.toInt
                resetView(indexOfSelectedButton)
                changeButtonState(for: indexOfSelectedButton, state: state)
            }
        }
    }
    
    public func setResult(userAnswer: [Int], correctAnswer: [Int]){
        for index in 0..<userAnswer.count {
            if userAnswer[index]==correctAnswer[index]{
                let indexOfSelectedButton = 2 * index + userAnswer[index]
                changeButtonState(for: indexOfSelectedButton, state: .correct)
            }
            else {
                changeButtonState(for: 2 * index + correctAnswer[index], state: .correct)
                changeButtonState(for: 2 * index + userAnswer[index], state: .mistake)
            }
        }
    }

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
            make.top.equalTo(orderNumberLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.45)
        })
     
        addSubview(answerStackView)
        answerStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        questionImageView.load(from: model.imageUrl)
    }
}

class ReadingQuestionPartTwoCollectionViewCell: ReadingQuestionCollectionViewCell {
    
    private var cardViews: [CardView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalTo(orderNumberLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
        })

        contentView.addSubview(answerStackView)
        answerStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(3)
            make.centerX.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardViews.removeAll()
    }
    
    override func changeButtonState(for index: Int, state: AnswerState) {
        cardViews[index].setState(state)
    }
    
    override func resetView(){
        cardViews.forEach({
            $0.reset()
        })
    }
    
    @objc func didTapCardView(_ sender: UITapGestureRecognizer){
        if let cardView = sender.view as? CardView {
            resetView()
            cardView.setState(.chosen)
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
        // TODO: Rename url to path
        for url in model.imageUrls{
            let cardView = CardView()
            answerStackView.addArrangedSubview(cardView)
            cardView.cardImageView.load(from: url)
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
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
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
        super.init(coder: coder)
    }
    
    override func configure(with viewModel: QuestionCellViewModel) {
        super.configure(with: viewModel)
        guard let model = viewModel as? ReadingPartThreeViewModel else {return}
        descriptionLabel.text = model.description
        questionLabel.text = model.text
        questionImageView.load(from: model.imageUrl)
        answerStackView.addArrangedSubview(falseButton)
        answerStackView.addArrangedSubview(trueButton)
        buttons.append(falseButton)
        buttons.append(trueButton)
    }
}


