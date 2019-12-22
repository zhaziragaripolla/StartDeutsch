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
}

class ReadingQuestionPartOneCollectionViewCell: UICollectionViewCell {
    
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
        stackView.addArrangedSubview(UIButton.makeForBinaryQuestion(true))
        stackView.addArrangedSubview(UIButton.makeForBinaryQuestion(false))
        return stackView
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .leading
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
            make.height.equalToSuperview().multipliedBy(0.5)
        })
        
        addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
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
        }
        questionImageView.load(url: model.imageUrl)
    }
}
