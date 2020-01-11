//
//  ReadingQuestionPartThreeCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ReadingQuestionPartThreeCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ReadingQuestionDelegate?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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
    
    private var answerButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
//        stackView.addArrangedSubview(trueButton)
//        stackView.addArrangedSubview(falseButton)
        return stackView
    }()
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        delegate?.didSelectSignleAnswer(cell: self, answer: sender.tag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRandomGradient()
        
        trueButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)

        answerButtonsStackView.addArrangedSubview(trueButton)
        answerButtonsStackView.addArrangedSubview(falseButton)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.8)
        })
        
        contentView.addSubview(questionImageView)
        questionImageView.snp.makeConstraints({ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.8)
        })
        
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.2)
        })
        
        contentView.addSubview(answerButtonsStackView)
        answerButtonsStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReadingQuestionPartThreeCollectionViewCell: CellConfigurable{
    func configure(with viewModel: QuestionCellViewModel) {
        guard let model = viewModel as? ReadingPartThreeViewModel else {return}
        descriptionLabel.text = model.description
        questionLabel.text = model.questionText
        questionImageView.load(url: model.imageUrl)
    }
}

