//
//  ReadingQuestionPartOneCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

protocol QuestionCellViewModel {}

protocol CellConfigurable: class {
    func configure(with viewModel: QuestionCellViewModel)
    var delegate: ReadingQuestionDelegate? { get set }
}

protocol ReadingQuestionDelegate: class {
    func didSelectMultipleAnswer(cell: UICollectionViewCell, answers: [Bool?])
    func didSelectSignleAnswer(cell: UICollectionViewCell, answer: Bool)
}

class ReadingQuestionPartOneCollectionViewCell: UICollectionViewCell {
    
    var answers: [Bool?] = []
    var buttons: [UIButton] = []
    
    // Used for assigning a tag for generated buttons.
    var indexCounter = 0
    
    // There is only 2 type of buttons that user can tap to choose an answer: True or False. We have multiple questions with set of true/false buttons for each. This variable is required for calculating the index of question when user taps a button.
    var n = 2
    
    weak var delegate: ReadingQuestionDelegate?
    
    private var questionLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }
   
    private var answerButtonsStackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        let b1 = UIButton.makeForBinaryQuestion(true)
        b1.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        b1.tag = indexCounter
        indexCounter += 1
        stackView.addArrangedSubview(b1)
        let b2 = UIButton.makeForBinaryQuestion(false)
        b2.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        b2.tag = indexCounter
        indexCounter += 1
        stackView.addArrangedSubview(b2)
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
        stackView.alignment = .leading
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
        stackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(50)
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
