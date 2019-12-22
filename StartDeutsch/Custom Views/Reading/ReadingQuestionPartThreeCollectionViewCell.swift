//
//  ReadingQuestionPartThreeCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ReadingQuestionPartThreeCollectionViewCell: UICollectionViewCell {
    
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
    
    private let answerButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(UIButton.makeForBinaryQuestion(true))
        stackView.addArrangedSubview(UIButton.makeForBinaryQuestion(false))
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.trailing.leading.equalToSuperview()
        })
        
        addSubview(questionImageView)
        questionImageView.snp.makeConstraints({ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.8)
        })
        
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        })
        
        addSubview(answerButtonsStackView)
        answerButtonsStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
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

